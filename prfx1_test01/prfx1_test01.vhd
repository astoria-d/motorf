library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

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
		signal clk80m     : in std_logic;
		signal oe_n			: in std_logic;
		signal reset_n		: in std_logic;
		signal indata		: out std_logic_vector( 15 downto 0 );
		signal trig			: out std_logic
	);
end component;

component dac_spi_out
   port (
		signal clk80m     : in std_logic;
		signal indata		: in std_logic_vector( 15 downto 0 );
		signal trig			: in std_logic;

		signal spiclk		: out std_logic;
		signal spics		: out std_logic;
		signal sdi			: out std_logic
	);
END component;


signal clk80m  : std_logic;
signal sin : std_logic_vector( 15 downto 0 );
signal cos : std_logic_vector( 15 downto 0 );

signal reset_n : std_logic;

signal spi_data_trigger : std_logic;
signal spi_data : std_logic_vector( 15 downto 0 );
signal spi_dac_oe_n : std_logic;

constant RESET_WAIT1 : integer := 10;

begin

	dac_clk <= clk80m;

   led_p : process (clk16m)
	variable cnt : integer range 0 to 5 := 0;
   begin
		if (rising_edge(clk16m)) then
			led1 <= sw1;
			led2 <= sw2;
			led3 <= '0';
			reset_n <= not sw1;
		end if;
	end process;

   set_p : process (clk16m)
	variable cnt : integer range 0 to 10000 := 0;
   begin
		if (rising_edge(clk16m)) then
			if (reset_n = '0') then
				cnt := 0;
				spi_dac_oe_n <= '1';
			else
				if (cnt < RESET_WAIT1) then
					cnt := cnt + 1;
					spi_dac_oe_n <= '1';
				else
					spi_dac_oe_n <= '0';
				end if;
			end if;
		end if;
	end process;

	PLL_inst : PLL PORT MAP (
		inclk0	=> clk16m,
		c0	 		=> clk80m
	);

	NCO_1MHz : MY_NCO PORT MAP (
		clk	=> clk80m,
		frq   => conv_std_logic_vector(53687091, 32),
		sin	=> sin,
		cos	=> cos
	);

	DDR_OUT_inst : DDR_OUT PORT MAP (
		datain_h	=> sin (15 downto 2),
		datain_l	=> cos (15 downto 2),
		outclock	=> clk80m,
		dataout	=> dac
	);

	dac_spi_init_data_inst : dac_spi_init_data PORT MAP (
		clk80m => clk80m,
		oe_n => spi_dac_oe_n,
		reset_n => reset_n,
		indata => spi_data,
		trig => spi_data_trigger
	);

	dac_spi_out_inst : dac_spi_out PORT MAP (
		clk80m => clk80m,
		indata=> spi_data,
		trig => spi_data_trigger,
		spiclk => spiclk,
		sdi => sdi,
		spics => spics_dac
	);

end rtl;
