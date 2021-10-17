library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity output_uart is 
	port (
	signal clk80m		: in std_logic;
	signal indata		: in std_logic_vector(31 downto 0);
	signal uart_out	: out std_logic
	);
end output_uart;

architecture rtl of output_uart is

signal cnt : std_logic_vector (3 downto 0) := (others => '0');
signal out_data_l : std_logic_vector (7 downto 0) := (others => '0');
signal out_data_h : std_logic_vector (7 downto 0) := (others => '0');

--ascii '0'
constant HEX_CH_BASE : std_logic_vector (7 downto 0) := conv_std_logic_vector(16#30#, 8);

begin

	conv_p : process (clk80m)
	variable oval : std_logic_vector (7 downto 0);
	begin
		if (rising_edge(clk80m)) then
			if (cnt = 0) then
				out_data_l <= indata(7 downto 0);
				out_data_h <= "0000" & indata(11 downto 8);
			end if;
			cnt <= cnt + 1;
			if (cnt < 8) then
				oval := HEX_CH_BASE + out_data_l;
				uart_out <= oval(conv_integer(cnt));
			else
				oval := HEX_CH_BASE + out_data_h;
				uart_out <= oval(conv_integer(cnt) - 8);
			end if;
		end if;
	end process;

end rtl;
