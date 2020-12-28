library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity tx_data is 
	PORT
	(
		signal clk16m : in std_logic;
		signal reset_n : in std_logic;
		signal next_sym_en : in std_logic;
		signal outdata : out std_logic_vector(31 downto 0)
	);
end tx_data;

architecture rtl of tx_data is

signal outdata_reg : std_logic_vector(6 downto 0);

begin

	outdata <= "0000000000000000000000000" & outdata_reg;

   set_p16m : process (clk16m)
   begin
		if (falling_edge(clk16m)) then
			if (reset_n = '0') then
				outdata_reg <= (others => '0');
			else
				if (next_sym_en = '1') then
					outdata_reg <= outdata_reg + 1;
				end if;
			end if;
		end if;
	end process;

end rtl;
