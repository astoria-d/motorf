
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity dac_spi_init_data is 
   port (
	signal clk80m     : in std_logic;
	signal reset_n		: in std_logic;
	signal indata		: out std_logic_vector( 15 downto 0 );
	signal trig			: out std_logic
	);
end dac_spi_init_data;

architecture rtl of dac_spi_init_data is

type spi_data_t is record
	addr : std_logic_vector(7 downto 0);
	data : std_logic_vector(7 downto 0);
end record;

type spi_data_arr_t is array(0 to 4) of spi_data_t;

constant SPI_CONTROL 	: integer := 16#00#;
constant POWER_DOWN 		: integer := 16#01#;
constant DATA_CONTROL 	: integer := 16#02#;
constant I_DAC_GAIN 		: integer := 16#03#;
constant I_RSET 			: integer := 16#04#;
constant I_RCML 			: integer := 16#05#;
constant Q_DAC_GAIN 		: integer := 16#06#;
constant Q_RSET 			: integer := 16#07#;
constant Q_RCML 			: integer := 16#08#;
constant AUX_DAC_Q 		: integer := 16#09#;
constant AUX_CTL_Q 		: integer := 16#0a#;
constant AUX_DAC_I 		: integer := 16#0b#;
constant AUX_CTL_I 		: integer := 16#0c#;
constant REF_REG 			: integer := 16#0d#;
constant CAL_CTL 			: integer := 16#0e#;
constant CAL_MEM 			: integer := 16#0f#;
constant MEM_ADDR 		: integer := 16#10#;
constant MEM_DATA 		: integer := 16#11#;
constant MEM_RW 			: integer := 16#12#;
constant CLK_MODE 		: integer := 16#14#;
constant VERSION 			: integer := 16#1f#;


--AD9117 SPI init data.
constant spi_data : spi_data_arr_t := (
	--reset
	(addr => conv_std_logic_vector(SPI_CONTROL, 8), data => conv_std_logic_vector(16#20#, 8)),
	--clear reset
	(addr => conv_std_logic_vector(SPI_CONTROL, 8), data => (others => '0')),
	--TWOS, SIMULBIT, DCOSGL
	(addr => conv_std_logic_vector(DATA_CONTROL, 8), data => conv_std_logic_vector(16#92#, 8)),
	--IRSETEN
	(addr => conv_std_logic_vector(I_RSET, 8), data => conv_std_logic_vector(16#80#, 8)),
	--QRSETEN
	(addr => conv_std_logic_vector(Q_RSET, 8), data => conv_std_logic_vector(16#80#, 8))
);


begin
   spi_p : process (clk80m)
	variable cnt5 : integer range 0 to 5 := 0;
	variable cnt16 : integer range 0 to 16 := 0;
   begin
		if (falling_edge(clk80m)) then
			if (reset_n = '0') then
				indata <= (others => '0');
				trig <= '1';
				cnt5 := 0;
				cnt16 := 0;
			else
				if (cnt5 < 5) then
					if (cnt16 < 16) then
						indata <= spi_data(cnt5).addr & spi_data(cnt5).data;
						trig <= '0';
						cnt16 := cnt16 + 1;
					else
						indata <= (others => '0');
						trig <= '1';
						cnt16 := 0;
						cnt5 := cnt5 + 1;
					end if;
				else
					indata <= (others => '0');
					trig <= '1';
				end if;
			end if;
		end if;
	end process;

end rtl;



--------------------------------
--------------------------------
--------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity dac_spi_out is 
   port (
	signal clk80m     : in std_logic;
	signal indata		: in std_logic_vector( 15 downto 0 );
	signal trig			: in std_logic;

	signal spiclk		: out std_logic;
	signal spics		: out std_logic;
	signal sdi			: out std_logic
	);
end dac_spi_out;

architecture rtl of dac_spi_out is


begin

	spiclk <= clk80m;

   spi_p : process (clk80m)
	variable cnt : integer range 0 to 16 := 0;
   begin
		if (falling_edge(clk80m)) then

			if (trig = '1') then
				cnt := 0;
				spics <= '1';
				sdi <= '1';
			else
				if (cnt < 16) then
					spics <= '0';
					sdi <= indata(15 - cnt);
					cnt := cnt + 1;
				else
					cnt := 0;
					spics <= '1';
				end if;
			end if;
		end if;
	end process;

end rtl;

