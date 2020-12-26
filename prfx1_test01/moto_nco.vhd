library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.conv_std_logic_vector;

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

signal phase32 : std_logic_vector(31 downto 0) := conv_std_logic_vector(0, 32);

signal judge0 : integer range 0 to 1;
signal phase0 : std_logic_vector(18 downto 0);
signal temp0 : signed(18 downto 0);
signal x0 : signed(18 downto 0);
signal y0 : signed(18 downto 0);

signal judge1 : integer range 0 to 1;
signal phase1 : std_logic_vector(18 downto 0);
signal temp1 : signed(18 downto 0);
signal x1 : signed(18 downto 0);
signal y1 : signed(18 downto 0);


signal judge2 : integer range 0 to 1;
signal phase2 : std_logic_vector(18 downto 0);
signal temp2 : signed(18 downto 0);
signal x2 : signed(18 downto 0);
signal y2 : signed(18 downto 0);

signal judge3 : integer range 0 to 1;
signal phase3 : std_logic_vector(18 downto 0);
signal temp3 : signed(18 downto 0);
signal x3 : signed(18 downto 0);
signal y3 : signed(18 downto 0);

signal judge4 : integer range 0 to 1;
signal phase4 : std_logic_vector(18 downto 0);
signal temp4 : signed(18 downto 0);
signal x4 : signed(18 downto 0);
signal y4 : signed(18 downto 0);

signal judge5 : integer range 0 to 1;
signal phase5 : std_logic_vector(18 downto 0);
signal temp5 : signed(18 downto 0);
signal x5 : signed(18 downto 0);
signal y5 : signed(18 downto 0);

signal judge6 : integer range 0 to 1;
signal phase6 : std_logic_vector(18 downto 0);
signal temp6 : signed(18 downto 0);
signal x6 : signed(18 downto 0);
signal y6 : signed(18 downto 0);

signal judge7 : integer range 0 to 1;
signal phase7 : std_logic_vector(18 downto 0);
signal temp7 : signed(18 downto 0);
signal x7 : signed(18 downto 0);
signal y7 : signed(18 downto 0);

signal judge8 : integer range 0 to 1;
signal phase8 : std_logic_vector(18 downto 0);
signal temp8 : signed(18 downto 0);
signal x8 : signed(18 downto 0);
signal y8 : signed(18 downto 0);

signal judge9 : integer range 0 to 1;
signal phase9 : std_logic_vector(18 downto 0);
signal temp9 : signed(18 downto 0);
signal x9 : signed(18 downto 0);
signal y9 : signed(18 downto 0);

signal judge10 : integer range 0 to 1;
signal phase10 : std_logic_vector(18 downto 0);
signal temp10 : signed(18 downto 0);
signal x10 : signed(18 downto 0);
signal y10 : signed(18 downto 0);

signal judge11 : integer range 0 to 1;
signal phase11 : std_logic_vector(18 downto 0);
signal temp11 : signed(18 downto 0);
signal x11 : signed(18 downto 0);
signal y11 : signed(18 downto 0);

signal judge12 : integer range 0 to 1;
signal phase12 : std_logic_vector(18 downto 0);
signal temp12 : signed(18 downto 0);
signal x12 : signed(18 downto 0);
signal y12 : signed(18 downto 0);

signal judge13 : integer range 0 to 1;
signal phase13 : std_logic_vector(18 downto 0);
signal temp13 : signed(18 downto 0);
signal x13 : signed(18 downto 0);
signal y13 : signed(18 downto 0);

signal judge14 : integer range 0 to 1;
signal phase14 : std_logic_vector(18 downto 0);
signal temp14 : signed(18 downto 0);
signal x14 : signed(18 downto 0);
signal y14 : signed(18 downto 0);

signal judge15 : integer range 0 to 1;
signal phase15 : std_logic_vector(18 downto 0);
signal temp15 : signed(18 downto 0);
signal x15 : signed(18 downto 0);
signal y15 : signed(18 downto 0);

signal judge16 : integer range 0 to 1;
signal phase16 : std_logic_vector(18 downto 0);
signal temp16 : signed(18 downto 0);
signal x16 : signed(18 downto 0);
signal y16 : signed(18 downto 0);

signal judge17 : integer range 0 to 1;
signal phase17 : std_logic_vector(18 downto 0);
signal temp17 : signed(18 downto 0);
signal x17 : signed(18 downto 0);
signal y17 : signed(18 downto 0);

signal phase18 : std_logic_vector(18 downto 0);


function rshift(op1 : in std_logic_vector; op2 : in std_logic_vector) return std_logic_vector is
variable temp : std_logic_vector (op1'range);
begin
	 return temp;
end rshift;

begin

   pipeline : process (clk)
	use ieee.std_logic_unsigned.all;
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

--///  step0 ////
--always@(posedge clk)begin
--	temp0 <= 	65536;	
--	x0 <= 131072;
--	y0 <= 131072;
--end
   step0 : process (clk)
	use ieee.std_logic_arith.conv_std_logic_vector;
   begin
		if (rising_edge(clk)) then
			temp0 <= to_signed(65536, 19);
			x0 <= to_signed(131072, 19);
			y0 <= to_signed(131072, 19);
		end if;
	end process;

--
--///  step1 ////
--always@(phase0[16:0] or temp0)begin
--	if(temp0<0)
--		judge1 <= 0;
--	else if(phase0[16:0]>=temp0)
--		judge1 <= 0;
--	else
--		judge1 <= 1;		
--end
	step1_jdg : process (phase0(16 downto 0), temp0)
	begin
		if (temp0 < 0) then
			judge1 <= 0;
		elsif (signed("00" & phase0(16 downto 0)) >= temp0) then
			judge1 <= 0;
		else
			judge1 <= 1;
		end if;
	end process;

--
--always@(posedge clk)begin
--	if(judge1==1)begin
--		temp1 <=temp0-38688;	
--		x1 <= x0 + y0/2;
--		y1 <= y0 - x0/2;		
--	end
--	else begin
--		temp1 <=temp0+38688;
--		x1 <= x0 - y0/2;
--		y1 <= y0 + x0/2;
--	end
--end
   step1 : process (clk)
--	variable sft_x : signed(18 downto 0);
--	variable sft_y : signed(18 downto 0);
   begin
		if (rising_edge(clk)) then

--for use ieee.std_logic_arith.all;
--			sft_x := SHR(x0, conv_std_logic_vector(1, 19));
--			sft_y := SHR(y0, conv_std_logic_vector(1, 19));

--old. not supported.
--https://stackoverflow.com/questions/36021163/sra-not-working-in-vhdl
--			sft_x := (x0 sra 1);
--			sft_y := (y0 sra 1);

--			sft_x := shift_right(x0, 1);
--			sft_y := shift_right(y0, 1);
			if (judge1 = 1) then
				temp1 <= temp0 - to_signed(38688, 19);
--				x1 <= x0 + sft_x;
--				y1 <= y0 - sft_y;
				x1 <= x0 + y0 / 2;
				y1 <= y0 - x0 / 2;		
			else
				temp1 <= temp0 + to_signed(38688, 19);
--				x1 <= x0 - sft_x;
--				y1 <= y0 + sft_y;
				x1 <= x0 - y0 / 2;
				y1 <= y0 + x0 / 2;
			end if;
		end if;
	end process;

--///  step2 ////
--always@(phase1[16:0] or temp1)begin
--	if(temp1<0)
--		judge2 <= 0;
--	else if(phase1[16:0]>=temp1)
--		judge2 <= 0;
--	else
--		judge2 <= 1;		
--end
	step2_jdg : process (phase1(16 downto 0), temp1)
	begin
		if (temp0 < 0) then
			judge2 <= 0;
		elsif (signed("00" & phase1(16 downto 0)) >= temp1) then
			judge2 <= 0;
		else
			judge2 <= 1;
		end if;
	end process;

--always@(posedge clk)begin
--	if(judge2==1)begin
--		temp2 <=temp1-20441;	
--		x2 <= x1 + y1/4;
--		y2 <= y1 - x1/4;		
--	end
--	else begin
--		temp2 <=temp1+20441;
--		x2 <= x1 - y1/4;
--		y2 <= y1 + x1/4;
--	end
--end
   step2 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge2 = 1) then
				temp2 <= temp0 - to_signed(20441, 19);
				x2 <= x1 + y1 / 4;
				y2 <= y1 - x1 / 4;
			else
				temp1 <= temp0 + to_signed(20441, 19);
				x2 <= x1 - y1 / 4;
				y2 <= y1 + x1 / 4;
			end if;
		end if;
	end process;

end rtl;
