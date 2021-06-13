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
				sdata <= tmp + conv_std_logic_vector(16#07ff#, 12);
			else
				sdata <= tmp - conv_std_logic_vector(16#07ff#, 12);
			end if;
		end if;
	end process;

end rtl;
