library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.conv_std_logic_vector;

entity conv_signed is 
	port (
	signal clk80m		: in std_logic;
	signal udata		: in std_logic_vector(11 downto 0);
	signal sdata		: out std_logic_vector(11 downto 0)
	);
end conv_signed;

architecture rtl of conv_signed is

begin


	-----still not work!!!!
	conv_p : process (clk80m)
	variable tmp : std_logic_vector(10 downto 0);
	begin
		if (rising_edge(clk80m)) then
			tmp := udata(11 downto 1);
			if (tmp(10) = '1') then
				--negative is two's complemental + 1.
--				sdata <= '1' & (not tmp + 1);
				sdata <= udata + conv_std_logic_vector(16#0fff#, 12);
			else
--				sdata <= '0' & tmp;
				sdata <= udata - conv_std_logic_vector(16#0fff#, 12);
			end if;
--			sdata <= udata - conv_std_logic_vector(16#0fff#, 12);
		end if;
	end process;

end rtl;
