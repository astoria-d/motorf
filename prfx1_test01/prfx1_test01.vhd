library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity prfx1_test01 is 
   port (
	signal clk16m     : in std_logic;
	signal dac 			: out std_logic_vector( 13 downto 0 );
	signal dac_clk		: out std_logic;

	signal spiclk		: out std_logic;
	signal sdi			: out std_logic;
	signal spics_dac	: out std_logic;
	signal spics_pll	: out std_logic;

	signal sw1     	: in std_logic;
	signal sw2     	: in std_logic;
	signal clk5m  		: out std_logic;
	signal led1			: out std_logic;
	signal led2			: out std_logic;
	signal led3			: out std_logic
	);
end prfx1_test01;

architecture rtl of prfx1_test01 is

component tx_data
	PORT
	(
		signal clk16m : in std_logic;
		signal reset_n : in std_logic;
		signal next_sym_en : in std_logic;
		signal tx_data_sym : out std_logic_vector(31 downto 0)
	);
END component;

component tx_baseband
	PORT
	(
		signal clk16m : in std_logic;
		signal clk80m : in std_logic;
		signal reset_n : in std_logic;
		signal tx_data : in std_logic_vector(31 downto 0);
		signal bb_i : out std_logic_vector(15 downto 0);
		signal bb_q : out std_logic_vector(15 downto 0);
		signal next_sym_en : out std_logic
	);
end component;

component upconv
	PORT
	(
		signal clk16m : in std_logic;
		signal clk80m : in std_logic;
		signal reset_n : in std_logic;
		signal bb_i : in std_logic_vector(15 downto 0);
		signal bb_q : in std_logic_vector(15 downto 0);
		signal if_i : out std_logic_vector(15 downto 0);
		signal if_q : out std_logic_vector(15 downto 0)
	);
END component;

component DDR_OUT
	PORT
	(
		datain_h		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datain_l		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		outclock		: IN STD_LOGIC ;
		dataout		: OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
	);
END component;

component PLL
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC ;
		c1		: OUT STD_LOGIC 
	);
END component;

component dac_spi_init_data
   port (
		signal clk16m     : in std_logic;
		signal oe_n			: in std_logic;
		signal reset_n		: in std_logic;
		signal indata		: out std_logic_vector( 15 downto 0 );
		signal trig			: out std_logic
	);
end component;

component pll_spi_init_data
   port (
	signal clk16m     : in std_logic;
	signal oe_n			: in std_logic;
	signal reset_n		: in std_logic;
	signal indata		: out std_logic_vector(31 downto 0);
	signal trig			: out std_logic
	);
end component;

component spi_out
	generic (bus_size : integer := 16);
   port (
	signal clk16m     : in std_logic;
	signal indata		: in std_logic_vector(bus_size - 1 downto 0);
	signal trig			: in std_logic;

	signal spics		: out std_logic;
	signal sdi			: out std_logic
	);
end component;

signal clk80m  : std_logic;
signal reset_n : std_logic;

signal bb_i : std_logic_vector(15 downto 0);
signal bb_q : std_logic_vector(15 downto 0);
signal if_i : std_logic_vector(15 downto 0);
signal if_q : std_logic_vector(15 downto 0);

signal dac_en : std_logic;
signal dac_spi_data : std_logic_vector(15 downto 0);
signal dac_spi_oe_n : std_logic;

signal pll_en : std_logic;
signal pll_spi_data : std_logic_vector(31 downto 0);
signal pll_spi_oe_n : std_logic;

signal dac_sdi		: std_logic;
signal pll_sdi		: std_logic;

constant RESET_WAIT1 : integer := 10;
constant RESET_WAIT2 : integer := 150;
constant RESET_INC_MAX : integer := 200;

signal next_sym_en : std_logic;
signal tx_data_sym : std_logic_vector(31 downto 0);

begin

	dac_clk <= clk80m;
	spiclk <= not clk16m;
	sdi <= dac_sdi and pll_sdi;

	tx_data_inst : tx_data PORT map
	(
		clk16m,
		reset_n,
		next_sym_en,
		tx_data_sym
	);

	tx_baseband_inst : tx_baseband port map
	(
		clk16m,
		clk80m,
		reset_n,
		tx_data_sym,
		bb_i,
		bb_q,
		next_sym_en
	);

	upconv_inst : upconv PORT map
	(
		clk16m,
		clk80m,
		reset_n,
		bb_i,
		bb_q,
		if_i,
		if_q
	);

	--DDR instance
	DDR_OUT_inst : DDR_OUT PORT MAP (
		datain_h	=> if_i (15 downto 2),
		datain_l	=> if_q (15 downto 2),
		outclock	=> clk80m,
		dataout	=> dac
	);

	--PLL instance
	PLL_inst : PLL PORT MAP (
		inclk0	=> clk16m,
		c0	 		=> clk80m,
		c1	 		=> clk5m
	);

	--16mhz flipflop setting
   set_p16 : process (clk16m)
	variable cnt : integer range 0 to 10000 := 0;
   begin
		if (rising_edge(clk16m)) then
			if (reset_n = '0') then
				cnt := 0;
				dac_spi_oe_n <= '1';
				pll_spi_oe_n <= '1';
			else
				if (cnt < RESET_INC_MAX) then
					cnt := cnt + 1;
				end if;

				if (cnt < RESET_WAIT1) then
					dac_spi_oe_n <= '1';
				else
					dac_spi_oe_n <= '0';
				end if;

				if (cnt < RESET_WAIT2) then
					pll_spi_oe_n <= '1';
				else
					pll_spi_oe_n <= '0';
				end if;
			end if;
		end if;
	end process;

	--dac parameter set module instance
	dac_spi_init_data_inst : dac_spi_init_data PORT MAP (
		clk16m => clk16m,
		oe_n => dac_spi_oe_n,
		reset_n => reset_n,
		indata => dac_spi_data,
		trig => dac_en
	);

	--pll parameter set module instance
	pll_spi_init_data_inst : pll_spi_init_data PORT MAP (
		clk16m => clk16m,
		oe_n => pll_spi_oe_n,
		reset_n => reset_n,
		indata => pll_spi_data,
		trig => pll_en
	);

	--spi output module for dac
	dac_spi_out_inst : spi_out generic map (16) PORT MAP (
		clk16m => clk16m,
		indata=> dac_spi_data,
		trig => dac_en,
		sdi => dac_sdi,
		spics => spics_dac
	);

	--spi output module for pll
	pll_spi_out_inst : spi_out generic map (32) PORT MAP (
		clk16m => clk16m,
		indata=> pll_spi_data,
		trig => pll_en,
		sdi => pll_sdi,
		spics => spics_pll
	);
	
	--led signal handling
   led_p : process (clk16m)
   begin
		if (rising_edge(clk16m)) then
			--sw1 = reset
			if (sw1 = '1') then
				led1 <= '0';
				led2 <= '0';
				led3 <= '0';
			else
				led1 <= sw2;
				led3 <= '1';
				if (tx_data_sym < 5000) then
					led2 <= '1';
				else
					led2 <= '0';
				end if;
			end if;
			reset_n <= not sw1;
		end if;
	end process;

end rtl;
