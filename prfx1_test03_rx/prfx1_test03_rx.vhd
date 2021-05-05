library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity prfx1_test03_rx is 
   port (
	signal clk16m     : in std_logic;
	signal adc 			: in std_logic_vector(11 downto 0);
	signal adc_clk		: out std_logic;

	signal spiclk		: out std_logic;
	signal sdi			: out std_logic;
	signal spics_pll	: out std_logic;

	signal sw1     	: in std_logic;
	signal sw2     	: in std_logic;
	signal led1			: out std_logic;
	signal led2			: out std_logic;
	signal led3			: out std_logic
	);
end prfx1_test03_rx;

architecture rtl of prfx1_test03_rx is

signal clk80m     : std_logic;
signal clk40m     : std_logic;
signal clk12m     : std_logic;
signal clk5m     : std_logic;

begin

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
				led2 <= not sw2;
				led3 <= '1';
			end if;
		end if;
	end process;


end rtl;
