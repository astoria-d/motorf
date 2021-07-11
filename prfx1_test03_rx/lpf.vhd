library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.conv_std_logic_vector;
use ieee.std_logic_unsigned.all;
use work.motorf.all;

entity lpf_28tap is 
	port (
	signal clk80m		: in std_logic;
	signal indata       : in std_logic_vector(11 downto 0);
	signal outdata      : out std_logic_vector(15 downto 0)
	);
end lpf_28tap;

architecture rtl of lpf_28tap is

signal indata1 : std_logic_vector(11 downto 0);
signal indata2 : std_logic_vector(11 downto 0);
signal indata3 : std_logic_vector(11 downto 0);
signal indata4 : std_logic_vector(11 downto 0);
signal indata5 : std_logic_vector(11 downto 0);
signal indata6 : std_logic_vector(11 downto 0);
signal indata7 : std_logic_vector(11 downto 0);
signal indata8 : std_logic_vector(11 downto 0);
signal indata9 : std_logic_vector(11 downto 0);
signal indata10 : std_logic_vector(11 downto 0);
signal indata11 : std_logic_vector(11 downto 0);
signal indata12 : std_logic_vector(11 downto 0);
signal indata13 : std_logic_vector(11 downto 0);
signal indata14 : std_logic_vector(11 downto 0);
signal indata15 : std_logic_vector(11 downto 0);
signal indata16 : std_logic_vector(11 downto 0);
signal indata17 : std_logic_vector(11 downto 0);
signal indata18 : std_logic_vector(11 downto 0);
signal indata19 : std_logic_vector(11 downto 0);
signal indata20 : std_logic_vector(11 downto 0);
signal indata21 : std_logic_vector(11 downto 0);
signal indata22 : std_logic_vector(11 downto 0);
signal indata23 : std_logic_vector(11 downto 0);
signal indata24 : std_logic_vector(11 downto 0);
signal indata25 : std_logic_vector(11 downto 0);
signal indata26 : std_logic_vector(11 downto 0);
signal indata27 : std_logic_vector(11 downto 0);
signal indata28 : std_logic_vector(11 downto 0);

--coefficients
constant coef1 : std_logic_vector(12 downto 0) := conv_std_logic_vector(-190, 13);
constant coef2 : std_logic_vector(12 downto 0) := conv_std_logic_vector(-163, 13);
constant coef3 : std_logic_vector(12 downto 0) := conv_std_logic_vector(-114, 13);
constant coef4 : std_logic_vector(12 downto 0) := conv_std_logic_vector(-43, 13);
constant coef5 : std_logic_vector(12 downto 0) := conv_std_logic_vector(47, 13);
constant coef6 : std_logic_vector(12 downto 0) := conv_std_logic_vector(153, 13);
constant coef7 : std_logic_vector(12 downto 0) := conv_std_logic_vector(270, 13);
constant coef8 : std_logic_vector(12 downto 0) := conv_std_logic_vector(392, 13);
constant coef9 : std_logic_vector(12 downto 0) := conv_std_logic_vector(514, 13);
constant coef10 : std_logic_vector(12 downto 0) := conv_std_logic_vector(628, 13);
constant coef11 : std_logic_vector(12 downto 0) := conv_std_logic_vector(729, 13);
constant coef12 : std_logic_vector(12 downto 0) := conv_std_logic_vector(810, 13);
constant coef13 : std_logic_vector(12 downto 0) := conv_std_logic_vector(867, 13);
constant coef14 : std_logic_vector(12 downto 0) := conv_std_logic_vector(896, 13);
constant coef15 : std_logic_vector(12 downto 0) := conv_std_logic_vector(896, 13);
constant coef16 : std_logic_vector(12 downto 0) := conv_std_logic_vector(867, 13);
constant coef17 : std_logic_vector(12 downto 0) := conv_std_logic_vector(810, 13);
constant coef18 : std_logic_vector(12 downto 0) := conv_std_logic_vector(729, 13);
constant coef19 : std_logic_vector(12 downto 0) := conv_std_logic_vector(628, 13);
constant coef20 : std_logic_vector(12 downto 0) := conv_std_logic_vector(514, 13);
constant coef21 : std_logic_vector(12 downto 0) := conv_std_logic_vector(392, 13);
constant coef22 : std_logic_vector(12 downto 0) := conv_std_logic_vector(270, 13);
constant coef23 : std_logic_vector(12 downto 0) := conv_std_logic_vector(153, 13);
constant coef24 : std_logic_vector(12 downto 0) := conv_std_logic_vector(47, 13);
constant coef25 : std_logic_vector(12 downto 0) := conv_std_logic_vector(-43, 13);
constant coef26 : std_logic_vector(12 downto 0) := conv_std_logic_vector(-114, 13);
constant coef27 : std_logic_vector(12 downto 0) := conv_std_logic_vector(-163, 13);
constant coef28 : std_logic_vector(12 downto 0) := conv_std_logic_vector(-190, 13);

signal multi1 : std_logic_vector(24 downto 0);
signal multi2 : std_logic_vector(24 downto 0);
signal multi3 : std_logic_vector(24 downto 0);
signal multi4 : std_logic_vector(24 downto 0);
signal multi5 : std_logic_vector(24 downto 0);
signal multi6 : std_logic_vector(24 downto 0);
signal multi7 : std_logic_vector(24 downto 0);
signal multi8 : std_logic_vector(24 downto 0);
signal multi9 : std_logic_vector(24 downto 0);
signal multi10 : std_logic_vector(24 downto 0);
signal multi11 : std_logic_vector(24 downto 0);
signal multi12 : std_logic_vector(24 downto 0);
signal multi13 : std_logic_vector(24 downto 0);
signal multi14 : std_logic_vector(24 downto 0);

signal sum1 : std_logic_vector(25 downto 0);
signal sum2 : std_logic_vector(25 downto 0);
signal pre_out : std_logic_vector(25 downto 0);
signal out_reg : std_logic_vector(15 downto 0);

signal toggle : std_logic := '0';


begin

	toggle_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			toggle <= not toggle;
		end if;
	end process;

	step_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (toggle = '1') then
				indata1 <= indata;
				indata2 <= indata1;
				indata3 <= indata2;
				indata4 <= indata3;
				indata5 <= indata4;
				indata6 <= indata5;
				indata7 <= indata6;
				indata8 <= indata7;
				indata9 <= indata8;
				indata10 <= indata9;
				indata11 <= indata10;
				indata12 <= indata11;
				indata13 <= indata12;
				indata14 <= indata13;
				indata15 <= indata14;
				indata16 <= indata15;
				indata17 <= indata16;
				indata18 <= indata17;
				indata19 <= indata18;
				indata20 <= indata19;
				indata21 <= indata20;
				indata22 <= indata21;
				indata23 <= indata22;
				indata24 <= indata23;
				indata25 <= indata24;
				indata26 <= indata25;
				indata27 <= indata26;
				indata28 <= indata27;
			else
				indata1 <= indata1;
				indata2 <= indata2;
				indata3 <= indata3;
				indata4 <= indata4;
				indata5 <= indata5;
				indata6 <= indata6;
				indata7 <= indata7;
				indata8 <= indata8;
				indata9 <= indata9;
				indata10 <= indata10;
				indata11 <= indata11;
				indata12 <= indata12;
				indata13 <= indata13;
				indata14 <= indata14;
				indata15 <= indata15;
				indata16 <= indata16;
				indata17 <= indata17;
				indata18 <= indata18;
				indata19 <= indata19;
				indata20 <= indata20;
				indata21 <= indata21;
				indata22 <= indata22;
				indata23 <= indata23;
				indata24 <= indata24;
				indata25 <= indata25;
				indata26 <= indata26;
				indata27 <= indata27;
				indata28 <= indata28;
			end if;
		end if;
	end process;

	mul_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (toggle /= '1') then
				multi1 <= indata1 * coef1;
				multi2 <= indata3 * coef3;
				multi3 <= indata5 * coef5;
				multi4 <= indata7 * coef7;
				multi5 <= indata9 * coef9;	
				multi6 <= indata11 * coef11;
				multi7 <= indata13 * coef13;
				multi8 <= indata15 * coef15;
				multi9 <= indata17 * coef17;
				multi10 <= indata19 * coef19;
				multi11 <= indata21 * coef21;
				multi12 <= indata23 * coef23;
				multi13 <= indata25 * coef25;
				multi14 <= indata27 * coef27;
			else
				multi1 <= indata2 * coef2;
				multi2 <= indata4 * coef4;
				multi3 <= indata6 * coef6;
				multi4 <= indata8 * coef8;
				multi5 <= indata10 * coef10;	
				multi6 <= indata12 * coef12;
				multi7 <= indata14 * coef14;
				multi8 <= indata16 * coef16;
				multi9 <= indata18 * coef18;
				multi10 <= indata20 * coef20;
				multi11 <= indata22 * coef22;
				multi12 <= indata24 * coef24;
				multi13 <= indata26 * coef26;
				multi14 <= indata28 * coef28;
			end if;
		end if;
	end process;

	sum_p : process (clk80m)
	begin
--		need to extend with sign!!!!!
		sum1 <= sign_extend_24_to_25(multi1)
			+ sign_extend_24_to_25(multi2)
			+ sign_extend_24_to_25(multi3)
			+ sign_extend_24_to_25(multi4)
			+ sign_extend_24_to_25(multi5)
			+ sign_extend_24_to_25(multi6)
			+ sign_extend_24_to_25(multi7);
		sum2 <= sign_extend_24_to_25(multi8)
		+ sign_extend_24_to_25(multi9)
		+ sign_extend_24_to_25(multi10)
		+ sign_extend_24_to_25(multi11)
		+ sign_extend_24_to_25(multi12)
		+ sign_extend_24_to_25(multi13)
		+ sign_extend_24_to_25(multi14);
	end process;

	final_p : process (clk80m)
	begin
			if (toggle = '1') then
				pre_out <= sum1 + sum2;
			else
				pre_out <= pre_out+sum1 + sum2;
			end if;
	end process;

	outdata <= out_reg;

	out_p : process (clk80m)
	begin
			if (toggle = '1') then
				out_reg <= pre_out(23 downto 8);
			else
				out_reg <= out_reg;		
			end if;
	end process;

end rtl;
