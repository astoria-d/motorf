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
	signal led1			: out std_logic;
	signal led2			: out std_logic;
	signal led3			: out std_logic
	);
end prfx1_test01;

architecture rtl of prfx1_test01 is

component PLL
	PORT
	(
		inclk0	: IN STD_LOGIC  := '0';
		c0			: OUT STD_LOGIC 
	);
END component;

component MY_NCO
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out std_logic_vector( 15 downto 0 );
		cos : out std_logic_vector( 15 downto 0 )
	);
END component;

component moto_nco
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out std_logic_vector( 15 downto 0 );
		cos : out std_logic_vector( 15 downto 0 )
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

component wave_mem
	generic (mif_file : string := "null-file.mif");
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
end component;

signal clk80m  : std_logic;
signal sin : std_logic_vector(15 downto 0);
signal cos : std_logic_vector(15 downto 0);

signal reset_n : std_logic;

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

constant CNT_100_MAX : integer := 100 - 1;
constant CNT_76US_MAX : integer := 76 * 16 - 1;
signal count_100sym	: integer range 0 to CNT_100_MAX := 0;
signal count_76us		: integer range 0 to CNT_76US_MAX:= 0;

signal address : std_logic_vector(8 downto 0);
signal bb_data_sin4 : std_logic_vector(15 downto 0);
signal bb_data_sin8 : std_logic_vector(15 downto 0);
signal bb_data_sin12 : std_logic_vector(15 downto 0);
signal bb_data_sin16 : std_logic_vector(15 downto 0);

signal bb_data_cos4 : std_logic_vector(15 downto 0);
signal bb_data_cos8 : std_logic_vector(15 downto 0);
signal bb_data_cos12 : std_logic_vector(15 downto 0);
signal bb_data_cos16 : std_logic_vector(15 downto 0);

begin

	dac_clk <= clk80m;
	spiclk <= clk16m;
	sdi <= dac_sdi and pll_sdi;

	--PLL instance
	PLL_inst : PLL PORT MAP (
		inclk0	=> clk16m,
		c0	 		=> clk80m
	);

	--DDR instance
	DDR_OUT_inst : DDR_OUT PORT MAP (
		datain_h	=> sin (15 downto 2),
		datain_l	=> cos (15 downto 2),
		outclock	=> clk80m,
		dataout	=> dac
	);

--	--NCO instance
--	NCO_1MHz : MY_NCO PORT MAP (
--		clk	=> clk80m,
--		frq   => conv_std_logic_vector(53687091, 32),
--		sin	=> sin,
--		cos	=> cos
--	);

	--NCO instance
	NCO_1MHz : moto_nco PORT MAP (
		clk	=> clk80m,
		frq   => conv_std_logic_vector(53687091, 32),
		sin	=> sin,
		cos	=> cos
	);

	--baseband
	sin4_inst : wave_mem generic map ("wave-sin4.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin4
	);
	sin8_inst : wave_mem generic map ("wave-sin8.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin8
	);
	sin12_inst : wave_mem generic map ("wave-sin12.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin12
	);
	sin16_inst : wave_mem generic map ("wave-sin16.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_sin16
	);

	cos4_inst : wave_mem generic map ("wave-cos4.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos4
	);
	cos8_inst : wave_mem generic map ("wave-cos8.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos8
	);
	cos12_inst : wave_mem generic map ("wave-cos12.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos12
	);
	cos16_inst : wave_mem generic map ("wave-cos16.mif")
	PORT MAP (
		address   => address,
		clock	=> clk16m,
		q	=> bb_data_cos16
	);
	
	--16mhz flipflop setting
   set_p16 : process (clk16m)
	variable cnt : integer range 0 to 10000 := 0;
   begin
		if (falling_edge(clk16m)) then
			if (reset_n = '0') then
				cnt := 0;
				dac_spi_oe_n <= '1';
				pll_spi_oe_n <= '1';
				count_100sym <= 0;
				count_76us <= 0;
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
				
				if (count_76us < CNT_76US_MAX) then
					count_76us <= count_76us + 1;
				else
					count_76us <= 0;
				end if;

				if (count_76us = CNT_76US_MAX) then
					if (count_100sym < CNT_100_MAX) then
						count_100sym <= count_100sym + 1;
					else
						count_100sym <= 0;
					end if;

				end if;
			end if;
		end if;
	end process;

	--80mhz flipflop setting
   set_p80 : process (clk80m)
	variable cnt16 : integer range 0 to 15 := 0;
   begin
		if (falling_edge(clk80m)) then
			if (reset_n = '0') then
				cnt16 := 0;
				address <= (others => '0');
			else
				if (cnt16 = 15) then
					cnt16 := 0;
					address <= address + 1;
				else
					cnt16 := cnt16 + 1;
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
		if (falling_edge(clk16m)) then
			led1 <= sw1;
			led2 <= sw2;
			led3 <= '0';
			reset_n <= not sw1;
		end if;
	end process;

end rtl;
