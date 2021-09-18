library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity prfx1_test04_nco is 
   port (
	signal clk16m     : in std_logic;
	signal dac 			: out std_logic_vector( 13 downto 0 );
	signal dac_clk		: out std_logic;

	signal spiclk		: out std_logic;
	signal sdi			: out std_logic;
	signal spics_dac	: out std_logic;

	signal jtg_clk		: out std_logic;

	signal sw1     	: in std_logic;
	signal sw2     	: in std_logic;
	signal led1			: out std_logic;
	signal led2			: out std_logic;
	signal led3			: out std_logic
	);
end prfx1_test04_nco;

architecture rtl of prfx1_test04_nco is

component PLL
	PORT
	(
		inclk0		: IN STD_LOGIC  := '0';
		c0		: OUT STD_LOGIC
	);
END component;

component DDR_OUT
	PORT
	(
		datain_h		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		datain_l		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		outclock		: IN STD_LOGIC;
		dataout		: OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
	);
END component;

component nco_1mhz
	PORT
	(
		clk80m : in std_logic;
		sin : out std_logic_vector( 13 downto 0 );
		cos : out std_logic_vector( 13 downto 0 )
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

signal sin : std_logic_vector(13 downto 0);
signal cos : std_logic_vector(13 downto 0);

signal dac_en : std_logic;
signal dac_spi_data : std_logic_vector(15 downto 0);
signal dac_spi_oe_n : std_logic := '1';
signal dac_spi_rst_n : std_logic := '1';

begin

	jtg_clk <= clk80m;
	dac_clk <= clk80m;
	spiclk <= not clk16m;

	--PLL instance
	PLL_inst : PLL PORT MAP (
		inclk0	=> clk16m,
		c0	 		=> clk80m
	);

	--NCO instance, 875 KHz wave
	nco_inst : nco_1mhz PORT MAP (
		clk80m	=> clk80m,
		sin	=> sin,
		cos	=> cos
	);

	--DDR instance
	DDR_OUT_inst : DDR_OUT PORT MAP (
		datain_h	=> sin,
		datain_l	=> cos,
		outclock	=> clk80m,
		dataout	=> dac
	);

	--dac parameter set module instance
	dac_spi_init_data_inst : dac_spi_init_data PORT MAP (
		clk16m => clk16m,
		oe_n => dac_spi_oe_n,
		reset_n => dac_spi_rst_n,
		indata => dac_spi_data,
		trig => dac_en
	);

	--spi output module for dac
	dac_spi_out_inst : spi_out generic map (16) PORT MAP (
		clk16m => clk16m,
		indata=> dac_spi_data,
		trig => dac_en,
		sdi => sdi,
		spics => spics_dac
	);

	--led signal handling
   led_p : process (clk80m)
	variable cnt : std_logic_vector(24 downto 0) := (others => '0');
   begin
		if (rising_edge(clk80m)) then
			--sw1 = reset
			if (sw1 = '1') then
				led1 <= '0';
				led2 <= '0';
				led3 <= '0';
				cnt := (others => '0');
				dac_spi_rst_n <= '0';
				dac_spi_oe_n <= '1';
			else
				led1 <= sw2;
				led2 <= cnt(24);
				led3 <= '1';
				cnt := cnt + 1;
				if (dac_spi_rst_n = '0' and cnt(24) = '0') then
					dac_spi_rst_n <= '1';
				end if;
				dac_spi_oe_n <= not dac_spi_rst_n;
			end if;
		end if;
	end process;

end rtl;
