

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity timing_sync is 
	PORT
	(
		signal clk80m : in std_logic;
		signal symbol_cnt : out std_logic_vector(15 downto 0);
		signal symbol_num : out std_logic_vector(7 downto 0)
	);
end timing_sync;

architecture rtl of timing_sync is

signal symbol_cnt_reg : std_logic_vector(15 downto 0) := (others => '0');
signal symbol_num_reg : std_logic_vector(7 downto 0)  := (others => '0');

begin

	symbol_cnt <= symbol_cnt_reg;
	symbol_num <= symbol_num_reg;
	cnt_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conv_integer(symbol_cnt_reg) = 76 * 80 - 1) then
				symbol_cnt_reg <= (others => '0');
			else
				symbol_cnt_reg <= symbol_cnt_reg + 1;
			end if;
		end if;
	end process;

	num_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conv_integer(symbol_cnt_reg) = 76 * 80 - 1) then
				symbol_num_reg <= symbol_num_reg + 1;
			end if;
		end if;
	end process;

end rtl;


------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;

entity tx_data_gen is 
	PORT
	(
		signal clk80m : in std_logic;
		signal tx_data : out std_logic_vector(31 downto 0)
	);
end tx_data_gen;

architecture rtl of tx_data_gen is

signal outdata_reg : std_logic_vector(31 downto 0);

begin

	tx_data <= outdata_reg;
	set_p80m : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (conv_integer(outdata_reg) > 10000) then
				outdata_reg <= (others => '0');
			else
				outdata_reg <= outdata_reg + 1;
			end if;
		end if;
	end process;

end rtl;
