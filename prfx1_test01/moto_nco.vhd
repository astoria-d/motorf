library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity moto_nco is 
	PORT
	(
		clk : in std_logic;
		frq : in std_logic_vector( 31 downto 0 );
		sin : out std_logic_vector( 15 downto 0 );
		cos : out std_logic_vector( 15 downto 0 )
	);
end moto_nco;

architecture rtl of moto_nco is

signal phase32 : std_logic_vector(31 downto 0);

signal judge0 : integer range 0 to 1;
signal phase0 : std_logic_vector(18 downto 0);
signal temp0 : std_logic_vector(18 downto 0);
signal x0 : std_logic_vector(18 downto 0);
signal y0 : std_logic_vector(18 downto 0);

signal judge1 : integer range 0 to 1;
signal phase1 : std_logic_vector(18 downto 0);
signal temp1 : std_logic_vector(18 downto 0);
signal x1 : std_logic_vector(18 downto 0);
signal y1 : std_logic_vector(18 downto 0);

signal judge2 : integer range 0 to 1;
signal phase2 : std_logic_vector(18 downto 0);
signal temp2 : std_logic_vector(18 downto 0);
signal x2 : std_logic_vector(18 downto 0);
signal y2 : std_logic_vector(18 downto 0);


signal judge3 : integer range 0 to 1;
signal phase3 : std_logic_vector(18 downto 0);
signal temp3 : std_logic_vector(18 downto 0);
signal x3 : std_logic_vector(18 downto 0);
signal y3 : std_logic_vector(18 downto 0);

signal judge4 : integer range 0 to 1;
signal phase4 : std_logic_vector(18 downto 0);
signal temp4 : std_logic_vector(18 downto 0);
signal x4 : std_logic_vector(18 downto 0);
signal y4 : std_logic_vector(18 downto 0);

signal judge5 : integer range 0 to 1;
signal phase5 : std_logic_vector(18 downto 0);
signal temp5 : std_logic_vector(18 downto 0);
signal x5 : std_logic_vector(18 downto 0);
signal y5 : std_logic_vector(18 downto 0);

signal judge6 : integer range 0 to 1;
signal phase6 : std_logic_vector(18 downto 0);
signal temp6 : std_logic_vector(18 downto 0);
signal x6 : std_logic_vector(18 downto 0);
signal y6 : std_logic_vector(18 downto 0);

signal judge7 : integer range 0 to 1;
signal phase7 : std_logic_vector(18 downto 0);
signal temp7 : std_logic_vector(18 downto 0);
signal x7 : std_logic_vector(18 downto 0);
signal y7 : std_logic_vector(18 downto 0);

signal judge8 : integer range 0 to 1;
signal phase8 : std_logic_vector(18 downto 0);
signal temp8 : std_logic_vector(18 downto 0);
signal x8 : std_logic_vector(18 downto 0);
signal y8 : std_logic_vector(18 downto 0);

signal judge9 : integer range 0 to 1;
signal phase9 : std_logic_vector(18 downto 0);
signal temp9 : std_logic_vector(18 downto 0);
signal x9 : std_logic_vector(18 downto 0);
signal y9 : std_logic_vector(18 downto 0);

signal judge10 : integer range 0 to 1;
signal phase10 : std_logic_vector(18 downto 0);
signal temp10 : std_logic_vector(18 downto 0);
signal x10 : std_logic_vector(18 downto 0);
signal y10 : std_logic_vector(18 downto 0);

signal judge11 : integer range 0 to 1;
signal phase11 : std_logic_vector(18 downto 0);
signal temp11 : std_logic_vector(18 downto 0);
signal x11 : std_logic_vector(18 downto 0);
signal y11 : std_logic_vector(18 downto 0);

signal judge12 : integer range 0 to 1;
signal phase12 : std_logic_vector(18 downto 0);
signal temp12 : std_logic_vector(18 downto 0);
signal x12 : std_logic_vector(18 downto 0);
signal y12 : std_logic_vector(18 downto 0);

signal judge13 : integer range 0 to 1;
signal phase13 : std_logic_vector(18 downto 0);
signal temp13 : std_logic_vector(18 downto 0);
signal x13 : std_logic_vector(18 downto 0);
signal y13 : std_logic_vector(18 downto 0);

signal judge14 : integer range 0 to 1;
signal phase14 : std_logic_vector(18 downto 0);
signal temp14 : std_logic_vector(18 downto 0);
signal x14 : std_logic_vector(18 downto 0);
signal y14 : std_logic_vector(18 downto 0);

signal judge15 : integer range 0 to 1;
signal phase15 : std_logic_vector(18 downto 0);
signal temp15 : std_logic_vector(18 downto 0);
signal x15 : std_logic_vector(18 downto 0);
signal y15 : std_logic_vector(18 downto 0);

signal judge16 : integer range 0 to 1;
signal phase16 : std_logic_vector(18 downto 0);
signal temp16 : std_logic_vector(18 downto 0);
signal x16 : std_logic_vector(18 downto 0);
signal y16 : std_logic_vector(18 downto 0);

signal judge17 : integer range 0 to 1;
signal phase17 : std_logic_vector(18 downto 0);
signal temp17 : std_logic_vector(18 downto 0);
signal x17 : std_logic_vector(18 downto 0);
signal y17 : std_logic_vector(18 downto 0);

signal phase18 : std_logic_vector(18 downto 0);


function rshift(op1 : in std_logic_vector; op2 : in std_logic_vector) return std_logic_vector is
variable temp : std_logic_vector (op1'range);
begin
	 return temp;
end rshift;

begin

   pipeline : process (clk)
   begin
		if (rising_edge(clk)) then
			phase32 <= 	phase32 + frq;
			phase0 <= phase32(31 downto 13);
			phase1 <= phase0;
			phase2 <= phase1;
			phase3 <= phase2;
			phase4 <= phase3;
			phase5 <= phase4;
			phase6 <= phase5;
			phase7 <= phase6;
			phase8 <= phase7;
			phase9 <= phase8;
			phase10 <= phase9;
			phase11 <= phase10;
			phase12 <= phase11;
			phase13 <= phase12;
			phase14 <= phase13;
			phase15 <= phase14;
			phase16 <= phase15;
			phase17 <= phase16;
			phase18 <= phase17;
		end if;
	end process;

   step0 : process (clk)
   begin
		if (rising_edge(clk)) then
			temp0 <= conv_std_logic_vector(65536, 19);
			x0 <= conv_std_logic_vector(131072, 19);
			y0 <= conv_std_logic_vector(131072, 19);
		end if;
	end process;

	--step1
	judge1 <= 0 when ("00" & phase0(16 downto 0) or temp0) /= 0 else
				 0 when signed(phase0(16 downto 0)) >= signed(temp0) else
				 1;

   step1 : process (clk)
	variable sft_x : std_logic_vector(18 downto 0);
	variable sft_y : std_logic_vector(18 downto 0);
   begin
		if (rising_edge(clk)) then
			sft_x := SHR(x0, conv_std_logic_vector(1, 19));
			sft_y := SHR(y0, conv_std_logic_vector(1, 19));
			if (judge1 = 1) then
				temp1 <= temp0 - conv_std_logic_vector(38688, 19);
				x1 <= x0 + sft_x;
				y1 <= y0 - sft_y;
			else
				temp1 <= temp0 + conv_std_logic_vector(38688, 19);
				x1 <= x0 - sft_x;
				y1 <= y0 + sft_y;
			end if;
		end if;
	end process;

end rtl;
