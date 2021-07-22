library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.motorf.all;

entity lpf_28tap is 
	port (
	signal clk80m		: in std_logic;
	signal indata       : in std_logic_vector(11 downto 0);
	signal outdata      : out std_logic_vector(15 downto 0)
	);
end lpf_28tap;

architecture rtl of lpf_28tap is

--coefficients
constant coef1 : signed(11 downto 0) := conv_signed(-190, 12);
constant coef2 : signed(11 downto 0) := conv_signed(-163, 12);
constant coef3 : signed(11 downto 0) := conv_signed(-114, 12);
constant coef4 : signed(11 downto 0) := conv_signed(-43, 12);
constant coef5 : signed(11 downto 0) := conv_signed(47, 12);
constant coef6 : signed(11 downto 0) := conv_signed(153, 12);
constant coef7 : signed(11 downto 0) := conv_signed(270, 12);
constant coef8 : signed(11 downto 0) := conv_signed(392, 12);
constant coef9 : signed(11 downto 0) := conv_signed(514, 12);
constant coef10 : signed(11 downto 0) := conv_signed(628, 12);
constant coef11 : signed(11 downto 0) := conv_signed(729, 12);
constant coef12 : signed(11 downto 0) := conv_signed(810, 12);
constant coef13 : signed(11 downto 0) := conv_signed(867, 12);
constant coef14 : signed(11 downto 0) := conv_signed(896, 12);
constant coef15 : signed(11 downto 0) := conv_signed(896, 12);
constant coef16 : signed(11 downto 0) := conv_signed(867, 12);
constant coef17 : signed(11 downto 0) := conv_signed(810, 12);
constant coef18 : signed(11 downto 0) := conv_signed(729, 12);
constant coef19 : signed(11 downto 0) := conv_signed(628, 12);
constant coef20 : signed(11 downto 0) := conv_signed(514, 12);
constant coef21 : signed(11 downto 0) := conv_signed(392, 12);
constant coef22 : signed(11 downto 0) := conv_signed(270, 12);
constant coef23 : signed(11 downto 0) := conv_signed(153, 12);
constant coef24 : signed(11 downto 0) := conv_signed(47, 12);
constant coef25 : signed(11 downto 0) := conv_signed(-43, 12);
constant coef26 : signed(11 downto 0) := conv_signed(-114, 12);
constant coef27 : signed(11 downto 0) := conv_signed(-163, 12);
constant coef28 : signed(11 downto 0) := conv_signed(-190, 12);

signal indata1 : signed(11 downto 0);
signal indata2 : signed(11 downto 0);
signal indata3 : signed(11 downto 0);
signal indata4 : signed(11 downto 0);
signal indata5 : signed(11 downto 0);
signal indata6 : signed(11 downto 0);
signal indata7 : signed(11 downto 0);
signal indata8 : signed(11 downto 0);
signal indata9 : signed(11 downto 0);
signal indata10 : signed(11 downto 0);
signal indata11 : signed(11 downto 0);
signal indata12 : signed(11 downto 0);
signal indata13 : signed(11 downto 0);
signal indata14 : signed(11 downto 0);
signal indata15 : signed(11 downto 0);
signal indata16 : signed(11 downto 0);
signal indata17 : signed(11 downto 0);
signal indata18 : signed(11 downto 0);
signal indata19 : signed(11 downto 0);
signal indata20 : signed(11 downto 0);
signal indata21 : signed(11 downto 0);
signal indata22 : signed(11 downto 0);
signal indata23 : signed(11 downto 0);
signal indata24 : signed(11 downto 0);
signal indata25 : signed(11 downto 0);
signal indata26 : signed(11 downto 0);
signal indata27 : signed(11 downto 0);
signal indata28 : signed(11 downto 0);

signal multi1 : signed(24 downto 0);
signal multi2 : signed(24 downto 0);
signal multi3 : signed(24 downto 0);
signal multi4 : signed(24 downto 0);
signal multi5 : signed(24 downto 0);
signal multi6 : signed(24 downto 0);
signal multi7 : signed(24 downto 0);
signal multi8 : signed(24 downto 0);
signal multi9 : signed(24 downto 0);
signal multi10 : signed(24 downto 0);
signal multi11 : signed(24 downto 0);
signal multi12 : signed(24 downto 0);
signal multi13 : signed(24 downto 0);
signal multi14 : signed(24 downto 0);

signal sum1 : signed(25 downto 0);
signal sum2 : signed(25 downto 0);
signal pre_out : signed(25 downto 0);
signal out_reg : signed(15 downto 0);

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
				indata1 <= signed(indata);
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
			if (toggle = '0') then
				multi1 <= mul_ex(indata1, coef1);
				multi2 <= mul_ex(indata3, coef3);
				multi3 <= mul_ex(indata5, coef5);
				multi4 <= mul_ex(indata7, coef7);
				multi5 <= mul_ex(indata9, coef9);	
				multi6 <= mul_ex(indata11, coef11);
				multi7 <= mul_ex(indata13, coef13);
				multi8 <= mul_ex(indata15, coef15);
				multi9 <= mul_ex(indata17, coef17);
				multi10 <= mul_ex(indata19, coef19);
				multi11 <= mul_ex(indata21, coef21);
				multi12 <= mul_ex(indata23, coef23);
				multi13 <= mul_ex(indata25, coef25);
				multi14 <= mul_ex(indata27, coef27);
			else
				multi1 <= mul_ex(indata2, coef2);
				multi2 <= mul_ex(indata4, coef4);
				multi3 <= mul_ex(indata6, coef6);
				multi4 <= mul_ex(indata8, coef8);
				multi5 <= mul_ex(indata10, coef10);	
				multi6 <= mul_ex(indata12, coef12);
				multi7 <= mul_ex(indata14, coef14);
				multi8 <= mul_ex(indata16, coef16);
				multi9 <= mul_ex(indata18, coef18);
				multi10 <= mul_ex(indata20, coef20);
				multi11 <= mul_ex(indata22, coef22);
				multi12 <= mul_ex(indata24, coef24);
				multi13 <= mul_ex(indata26, coef26);
				multi14 <= mul_ex(indata28, coef28);
			end if;
		end if;
	end process;

	sum_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			sum1 <= sign_extend_25_to_26(multi1)
				+ sign_extend_25_to_26(multi2)
				+ sign_extend_25_to_26(multi3)
				+ sign_extend_25_to_26(multi4)
				+ sign_extend_25_to_26(multi5)
				+ sign_extend_25_to_26(multi6)
				+ sign_extend_25_to_26(multi7);
			sum2 <= sign_extend_25_to_26(multi8)
				+ sign_extend_25_to_26(multi9)
				+ sign_extend_25_to_26(multi10)
				+ sign_extend_25_to_26(multi11)
				+ sign_extend_25_to_26(multi12)
				+ sign_extend_25_to_26(multi13)
				+ sign_extend_25_to_26(multi14);
		end if;
	end process;

	final_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (toggle = '0') then
				pre_out <= sum1 + sum2;
			else
				pre_out <= pre_out + sum1 + sum2;
			end if;
		end if;
	end process;

	outdata <= std_logic_vector(out_reg);

	out_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			if (toggle = '1') then
				out_reg <= pre_out(23 downto 8);
			else
				out_reg <= out_reg;		
			end if;
		end if;
	end process;

end rtl;
