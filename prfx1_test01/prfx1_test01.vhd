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
	signal spics		: out std_logic;

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

component spi_init_data
   port (
		signal clk80m     : in std_logic;
		signal reset_n		: in std_logic;
		signal indata		: out std_logic_vector( 15 downto 0 );
		signal trig			: out std_logic
	);
end component;

component spi_out_dac
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

signal reset_n : std_logic := '1';

signal spi_data_trigger : std_logic;
signal spi_data : std_logic_vector( 15 downto 0 );

begin

	dac_clk <= clk80m;

   LED_set_p : process (clk16m)
	variable rst_cnt : integer range 0 to 1600000 := 0;
   begin
		if (rising_edge(clk16m)) then
			led1 <= sw2;
			led2 <= sw1;
			led3 <= '0';

			if (sw1 = '1') then
				reset_n <= '0';
			else
				----1,600,000 clk (100ms) is reset period.
				if (rst_cnt < 1600000) then
					rst_cnt := rst_cnt + 1;
				else
					reset_n <= '0';
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
		sin	=> sin,
		cos	=> cos,
		frq   => conv_std_logic_vector(53687091, 32)
	);

	DDR_OUT_inst : DDR_OUT PORT MAP (
		datain_h	=> sin (13 downto 0),
		datain_l	=> cos (13 downto 0),
		outclock	=> clk80m,
		dataout	=> dac
	);

	SPI_DATA_inst : spi_init_data PORT MAP (
		clk80m => clk80m,
		reset_n => reset_n,
		indata => spi_data,
		trig => spi_data_trigger
	);

	SPI_OUT_inst : spi_out_dac PORT MAP (
		clk80m => clk80m,
		indata=> spi_data,
		trig => spi_data_trigger,
		spiclk => spiclk,
		sdi => sdi,
		spics => spics
	);

end rtl;
