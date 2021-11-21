library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity output_uart is 
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(7 downto 0);
	signal uart_out	: out std_logic
	);
end output_uart;

architecture rtl of output_uart is

--ascii '0'
constant HEX_CH_BASE : std_logic_vector (7 downto 0) := conv_std_logic_vector(16#30#, 8);

begin

	conv_p : process (clk80m)
	variable cnt : std_logic_vector (2 downto 0) := (others => '0');
	variable oval : std_logic_vector (7 downto 0);
	begin
		if (rising_edge(clk80m)) then
			cnt := cnt + 1;
			oval := HEX_CH_BASE + indata;
			uart_out <= oval(conv_integer(cnt));
		end if;
	end process;

end rtl;
