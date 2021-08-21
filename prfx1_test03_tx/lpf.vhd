library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.motorf.all;

entity lpf_24tap is 
	port (
	signal clk80m		: in std_logic;
	signal indata       : in std_logic_vector(15 downto 0);
	signal outdata      : out std_logic_vector(15 downto 0)
	);
end lpf_24tap;

architecture rtl of lpf_24tap is

--coefficients
constant coef1 : signed(10 downto 0) := conv_signed(278, 11);
constant coef2 : signed(10 downto 0) := conv_signed(347, 11);
constant coef3 : signed(10 downto 0) := conv_signed(416, 11);
constant coef4 : signed(10 downto 0) := conv_signed(484, 11);
constant coef5 : signed(10 downto 0) := conv_signed(549, 11);
constant coef6 : signed(10 downto 0) := conv_signed(609, 11);
constant coef7 : signed(10 downto 0) := conv_signed(663, 11);
constant coef8 : signed(10 downto 0) := conv_signed(710, 11);
constant coef9 : signed(10 downto 0) := conv_signed(750, 11);
constant coef10 : signed(10 downto 0) := conv_signed(780, 11);
constant coef11 : signed(10 downto 0) := conv_signed(800, 11);
constant coef12 : signed(10 downto 0) := conv_signed(811, 11);
constant coef13 : signed(10 downto 0) := conv_signed(811, 11);
constant coef14 : signed(10 downto 0) := conv_signed(800, 11);
constant coef15 : signed(10 downto 0) := conv_signed(780, 11);
constant coef16 : signed(10 downto 0) := conv_signed(750, 11);
constant coef17 : signed(10 downto 0) := conv_signed(710, 11);
constant coef18 : signed(10 downto 0) := conv_signed(663, 11);
constant coef19 : signed(10 downto 0) := conv_signed(609, 11);
constant coef20 : signed(10 downto 0) := conv_signed(549, 11);
constant coef21 : signed(10 downto 0) := conv_signed(484, 11);
constant coef22 : signed(10 downto 0) := conv_signed(416, 11);
constant coef23 : signed(10 downto 0) := conv_signed(347, 11);
constant coef24 : signed(10 downto 0) := conv_signed(278, 11);

signal indata1 : signed(15 downto 0);
signal indata2 : signed(15 downto 0);
signal indata3 : signed(15 downto 0);
signal indata4 : signed(15 downto 0);
signal indata5 : signed(15 downto 0);
signal indata6 : signed(15 downto 0);
signal indata7 : signed(15 downto 0);
signal indata8 : signed(15 downto 0);
signal indata9 : signed(15 downto 0);
signal indata10 : signed(15 downto 0);
signal indata11 : signed(15 downto 0);
signal indata12 : signed(15 downto 0);
signal indata13 : signed(15 downto 0);
signal indata14 : signed(15 downto 0);
signal indata15 : signed(15 downto 0);
signal indata16 : signed(15 downto 0);
signal indata17 : signed(15 downto 0);
signal indata18 : signed(15 downto 0);
signal indata19 : signed(15 downto 0);
signal indata20 : signed(15 downto 0);
signal indata21 : signed(15 downto 0);
signal indata22 : signed(15 downto 0);
signal indata23 : signed(15 downto 0);
signal indata24 : signed(15 downto 0);

signal multi1 : signed(26 downto 0);
signal multi2 : signed(26 downto 0);
signal multi3 : signed(26 downto 0);
signal multi4 : signed(26 downto 0);
signal multi5 : signed(26 downto 0);
signal multi6 : signed(26 downto 0);
signal multi7 : signed(26 downto 0);
signal multi8 : signed(26 downto 0);
signal multi9 : signed(26 downto 0);
signal multi10 : signed(26 downto 0);
signal multi11 : signed(26 downto 0);
signal multi12 : signed(26 downto 0);
signal multi13 : signed(26 downto 0);
signal multi14 : signed(26 downto 0);
signal multi15 : signed(26 downto 0);
signal multi16 : signed(26 downto 0);
signal multi17 : signed(26 downto 0);
signal multi18 : signed(26 downto 0);
signal multi19 : signed(26 downto 0);
signal multi20 : signed(26 downto 0);
signal multi21 : signed(26 downto 0);
signal multi22 : signed(26 downto 0);
signal multi23 : signed(26 downto 0);
signal multi24 : signed(26 downto 0);

signal sum1 : signed(28 downto 0);
signal sum2 : signed(28 downto 0);
signal sum3 : signed(28 downto 0);
signal pre_out : signed(28 downto 0);
signal out_reg : signed(15 downto 0);

begin

	step_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
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
		end if;
	end process;

	mul_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			multi1 <= indata1 * coef1;
			multi2 <= indata2 * coef2;
			multi3 <= indata3 * coef3;
			multi4 <= indata4 * coef4;
			multi5 <= indata5 * coef5;
			multi6 <= indata6 * coef6;
			multi7 <= indata7 * coef7;
			multi8 <= indata8 * coef8;
			multi9 <= indata9 * coef9;
			multi10 <= indata10 * coef10;
			multi11 <= indata11 * coef11;
			multi12 <= indata12 * coef12;
			multi13 <= indata13 * coef13;
			multi14 <= indata14 * coef14;
			multi15 <= indata15 * coef15;
			multi16 <= indata16 * coef16;
			multi17 <= indata17 * coef17;
			multi18 <= indata18 * coef18;
			multi19 <= indata19 * coef19;
			multi20 <= indata20 * coef20;
			multi21 <= indata21 * coef21;
			multi22 <= indata22 * coef22;
			multi23 <= indata23 * coef23;
			multi24 <= indata24 * coef24;
		end if;
	end process;

	sum_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			sum1 <= sign_extend_27_to_29(multi1)
				+ sign_extend_27_to_29(multi2)
				+ sign_extend_27_to_29(multi3)
				+ sign_extend_27_to_29(multi4)
				+ sign_extend_27_to_29(multi5)
				+ sign_extend_27_to_29(multi6)
				+ sign_extend_27_to_29(multi7)
				+ sign_extend_27_to_29(multi8);
			sum2 <= sign_extend_27_to_29(multi9)
				+ sign_extend_27_to_29(multi10)
				+ sign_extend_27_to_29(multi11)
				+ sign_extend_27_to_29(multi12)
				+ sign_extend_27_to_29(multi13)
				+ sign_extend_27_to_29(multi14)
				+ sign_extend_27_to_29(multi15)
				+ sign_extend_27_to_29(multi16);
			sum3 <= sign_extend_27_to_29(multi17)
				+ sign_extend_27_to_29(multi18)
				+ sign_extend_27_to_29(multi19)
				+ sign_extend_27_to_29(multi20)
				+ sign_extend_27_to_29(multi21)
				+ sign_extend_27_to_29(multi22)
				+ sign_extend_27_to_29(multi23)
				+ sign_extend_27_to_29(multi24);
		end if;
	end process;

	final_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			pre_out <= sum1 + sum2 + sum3;
		end if;
	end process;

	outdata <= std_logic_vector(out_reg);

	out_p : process (clk80m)
	begin
		if (rising_edge(clk80m)) then
			out_reg <= pre_out(28 downto 13);
		end if;
	end process;

end rtl;

