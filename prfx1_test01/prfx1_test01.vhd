library ieee;
use ieee.std_logic_1164.all;

entity prfx1_test01 is 
   port (
	signal in_clk     : in std_logic;
	signal sw1     	: in std_logic;
	signal sw2     	: in std_logic;
	signal led1		: out std_logic;
	signal led2		: out std_logic;
	signal led3		: out std_logic
	);
end prfx1_test01;

architecture rtl of prfx1_test01 is

begin

   LED_set_p : process (in_clk)
   begin
		if (rising_edge(in_clk)) then
			led1 <= sw1;
			led2 <= sw2;
			led3 <= '1';
		end if;
	end process;

end rtl;

