library ieee;
use ieee.std_logic_1164.all;

entity prfx1_test01 is 
   port (
	signal clk16m     : in std_logic;
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

signal clk80m  : std_logic;

begin

   LED_set_p : process (clk16m)
   begin
		if (rising_edge(clk16m)) then
			led1 <= sw1;
			led2 <= sw2;
			led3 <= '0';
		end if;
	end process;

	PLL_inst : PLL PORT MAP (
		inclk0	=> clk16m,
		c0	 		=> clk80m
	);

end rtl;

