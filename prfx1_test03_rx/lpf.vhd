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
constant coef1 : std_logic_vector(11 downto 0) := conv_std_logic_vector(-190, 12);
constant coef2 : std_logic_vector(11 downto 0) := conv_std_logic_vector(-163, 12);
constant coef3 : std_logic_vector(11 downto 0) := conv_std_logic_vector(-114, 12);
constant coef4 : std_logic_vector(11 downto 0) := conv_std_logic_vector(-43, 12);
constant coef5 : std_logic_vector(11 downto 0) := conv_std_logic_vector(47, 12);
constant coef6 : std_logic_vector(11 downto 0) := conv_std_logic_vector(153, 12);
constant coef7 : std_logic_vector(11 downto 0) := conv_std_logic_vector(270, 12);
constant coef8 : std_logic_vector(11 downto 0) := conv_std_logic_vector(392, 12);
constant coef9 : std_logic_vector(11 downto 0) := conv_std_logic_vector(514, 12);
constant coef10 : std_logic_vector(11 downto 0) := conv_std_logic_vector(628, 12);
constant coef11 : std_logic_vector(11 downto 0) := conv_std_logic_vector(729, 12);
constant coef12 : std_logic_vector(11 downto 0) := conv_std_logic_vector(810, 12);
constant coef13 : std_logic_vector(11 downto 0) := conv_std_logic_vector(867, 12);
constant coef14 : std_logic_vector(11 downto 0) := conv_std_logic_vector(896, 12);
constant coef15 : std_logic_vector(11 downto 0) := conv_std_logic_vector(896, 12);
constant coef16 : std_logic_vector(11 downto 0) := conv_std_logic_vector(867, 12);
constant coef17 : std_logic_vector(11 downto 0) := conv_std_logic_vector(810, 12);
constant coef18 : std_logic_vector(11 downto 0) := conv_std_logic_vector(729, 12);
constant coef19 : std_logic_vector(11 downto 0) := conv_std_logic_vector(628, 12);
constant coef20 : std_logic_vector(11 downto 0) := conv_std_logic_vector(514, 12);
constant coef21 : std_logic_vector(11 downto 0) := conv_std_logic_vector(392, 12);
constant coef22 : std_logic_vector(11 downto 0) := conv_std_logic_vector(270, 12);
constant coef23 : std_logic_vector(11 downto 0) := conv_std_logic_vector(153, 12);
constant coef24 : std_logic_vector(11 downto 0) := conv_std_logic_vector(47, 12);
constant coef25 : std_logic_vector(11 downto 0) := conv_std_logic_vector(-43, 12);
constant coef26 : std_logic_vector(11 downto 0) := conv_std_logic_vector(-114, 12);
constant coef27 : std_logic_vector(11 downto 0) := conv_std_logic_vector(-163, 12);
constant coef28 : std_logic_vector(11 downto 0) := conv_std_logic_vector(-190, 12);

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
			sum1 <= add_ex(multi1, multi2, multi3, multi4, multi5, multi6, multi7);
			sum2 <= add_ex(multi8, multi9, multi10, multi11, multi12, multi13, multi14);
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

	out_p2 : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			outdata <= out_reg;
		end if;
	end process;

--	out_p : process (clk80m)
--	begin
--		if (rising_edge(clk80m)) then
--			out_reg <= sign_extend_12_to_16(indata1)
--				+ sign_extend_12_to_16(indata2)
--				+ sign_extend_12_to_16(indata3)
--				+ sign_extend_12_to_16(indata4)
--				+ sign_extend_12_to_16(indata5)
--				+ sign_extend_12_to_16(indata6)
--				+ sign_extend_12_to_16(indata7)
--				+ sign_extend_12_to_16(indata8)
--				+ sign_extend_12_to_16(indata9)
--				+ sign_extend_12_to_16(indata10)
--				+ sign_extend_12_to_16(indata11)
--				+ sign_extend_12_to_16(indata12)
--				+ sign_extend_12_to_16(indata13)
--				+ sign_extend_12_to_16(indata14)
--				+ sign_extend_12_to_16(indata15)
--				+ sign_extend_12_to_16(indata16)
--				+ sign_extend_12_to_16(indata17)
--				+ sign_extend_12_to_16(indata18)
--				+ sign_extend_12_to_16(indata19)
--				+ sign_extend_12_to_16(indata20)
--				+ sign_extend_12_to_16(indata21)
--				+ sign_extend_12_to_16(indata22)
--				+ sign_extend_12_to_16(indata23)
--				+ sign_extend_12_to_16(indata24)
--				+ sign_extend_12_to_16(indata25)
--				+ sign_extend_12_to_16(indata26)
--				+ sign_extend_12_to_16(indata27)
--				+ sign_extend_12_to_16(indata28);
--		end if;
--	end process;

end rtl;
