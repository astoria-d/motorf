library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity sync_symbol is
	port (
	signal clk80m		: in std_logic;
	signal in_data		: in std_logic_vector(11 downto 0);
	signal symbol_num : out std_logic_vector(7 downto 0);
	signal symbol_cnt : out std_logic_vector(15 downto 0)
	);
end sync_symbol;

architecture rtl of sync_symbol is

signal frame_cnt : unsigned(23 downto 0);

begin
	frame_proc : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (frame_cnt = 76 * 80 * 100 * 6 - 1) then
				frame_cnt <= (others=> '0');
			else
				frame_cnt <= frame_cnt + 1;
			end if;
		end if;
	end process;

end rtl;
