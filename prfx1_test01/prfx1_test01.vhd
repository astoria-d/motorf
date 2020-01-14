library ieee;
use ieee.std_logic_1164.all;

--  
--   MOTO NES FPGA On GHDL Simulation Environment Virtual Cuicuit Board
--   All of the components are assembled and instanciated on this board.
--  

entity prfx1_test01 is 
   port (
	signal clk     : in std_logic;
	signal sw     	: in std_logic;
	signal led1		: out std_logic
	);
end prfx1_test01;

architecture rtl of prfx1_test01 is

begin

   LED_set_p : process (clk)
   begin
		if (rising_edge(clk)) then
			LED1 <= SW;
		end if;
	end process;

end rtl;

