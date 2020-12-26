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
--signal temp17 : signed(18 downto 0);
signal x17 : signed(18 downto 0);
signal y17 : signed(18 downto 0);

--signal phase18 : std_logic_vector(18 downto 0);


function rshift(op1 : in std_logic_vector; op2 : in std_logic_vector) return std_logic_vector is
variable temp : std_logic_vector (op1'range);
begin
	 return temp;
end rshift;

--module SHIFT10(indata,outdata);
--input [18:0] indata;
--output [18:0] outdata;
--
--reg [18:0] outdata;
--
--always@(indata)begin
--	if(indata[18])
--		outdata <= {10'h3FF,indata[18:10]};
--	else
--		outdata <= {10'h0,indata[18:10]};		
--end

function SHIFT10(indata : in signed) return signed is
variable outdata : signed(18 downto 0);
begin
	if (indata > 0) then
		outdata := "1111111111" & indata(18 downto 10);
	else
		outdata := "0000000000" & indata(18 downto 10);
	end if;
	return outdata;
end SHIFT10;

function SHIFT11(indata : in signed) return signed is
variable outdata : signed(18 downto 0);
begin
	if (indata > 0) then
		outdata := "11111111111" & indata(18 downto 11);
	else
		outdata := "00000000000" & indata(18 downto 11);
	end if;
	return outdata;
end SHIFT11;

function SHIFT12(indata : in signed) return signed is
variable outdata : signed(18 downto 0);
begin
	if (indata > 0) then
		outdata := "111111111111" & indata(18 downto 12);
	else
		outdata := "000000000000" & indata(18 downto 12);
	end if;
	return outdata;
end SHIFT12;

function SHIFT13(indata : in signed) return signed is
variable outdata : signed(18 downto 0);
begin
	if (indata > 0) then
		outdata := "1111111111111" & indata(18 downto 13);
	else
		outdata := "0000000000000" & indata(18 downto 13);
	end if;
	return outdata;
end SHIFT13;

function SHIFT14(indata : in signed) return signed is
variable outdata : signed(18 downto 0);
begin
	if (indata > 0) then
		outdata := "11111111111111" & indata(18 downto 14);
	else
		outdata := "00000000000000" & indata(18 downto 14);
	end if;
	return outdata;
end SHIFT14;

function SHIFT15(indata : in signed) return signed is
variable outdata : signed(18 downto 0);
begin
	if (indata > 0) then
		outdata := "111111111111111" & indata(18 downto 15);
	else
		outdata := "000000000000000" & indata(18 downto 15);
	end if;
	return outdata;
end SHIFT15;

function SHIFT16(indata : in signed) return signed is
variable outdata : signed(18 downto 0);
begin
	if (indata > 0) then
		outdata := "1111111111111111" & indata(18 downto 16);
	else
		outdata := "0000000000000000" & indata(18 downto 16);
	end if;
	return outdata;
end SHIFT16;

function SHIFT17(indata : in signed) return signed is
variable outdata : signed(18 downto 0);
begin
	if (indata > 0) then
		outdata := "11111111111111111" & indata(18 downto 17);
	else
		outdata := "00000000000000000" & indata(18 downto 17);
	end if;
	return outdata;
end SHIFT17;

function SHIFT18(indata : in signed) return signed is
variable outdata : signed(18 downto 0);
begin
	if (indata > 0) then
		outdata := "1111111111111111111";
	else
		outdata := "0000000000000000000";
	end if;
	return outdata;
end SHIFT18;





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
			--phase18 <= phase17;
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
   begin
		if (rising_edge(clk)) then
			if (judge1 = 1) then
				temp1 <= temp0 - to_signed(38688, 19);
				x1 <= x0 + y0 / 2;
				y1 <= y0 - x0 / 2;		
			else
				temp1 <= temp0 + to_signed(38688, 19);
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
		if (temp1 < 0) then
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
				temp2 <= temp1 - to_signed(20441, 19);
				x2 <= x1 + y1 / 4;
				y2 <= y1 - x1 / 4;
			else
				temp2 <= temp1 + to_signed(20441, 19);
				x2 <= x1 - y1 / 4;
				y2 <= y1 + x1 / 4;
			end if;
		end if;
	end process;

--///  step3 ////
--always@(phase2[16:0] or temp2)begin
--	if(temp2<0)
--		judge3 <= 0;
--	else if(phase2[16:0]>=temp2)
--		judge3 <= 0;
--	else
--		judge3 <= 1;		
--end
	step3_jdg : process (phase2(16 downto 0), temp2)
	begin
		if (temp2 < 0) then
			judge3 <= 0;
		elsif (signed("00" & phase2(16 downto 0)) >= temp2) then
			judge3 <= 0;
		else
			judge3 <= 1;
		end if;
	end process;

--always@(posedge clk)begin
--	if(judge3==1)begin
--		temp3 <=temp2-10376;	
--		x3 <= x2 + y2/8;
--		y3 <= y2 - x2/8;		
--	end
--	else begin
--		temp3 <=temp2+10376;
--		x3 <= x2 - y2/8;
--		y3 <= y2 + x2/8;
--	end
--end
   step3 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge3 = 1) then
				temp3 <= temp2 - to_signed(10376, 19);
				x3 <= x2 + y2 / 8;
				y3 <= y2 - x2 / 8;
			else
				temp3 <= temp2 + to_signed(10376, 19);
				x3 <= x2 - y2 / 8;
				y3 <= y2 + x2 / 8;
			end if;
		end if;
	end process;


--///  step4 ////
--always@(phase3[16:0] or temp3)begin
--	if(temp3<0)
--		judge4 <= 0;
--	else if(phase3[16:0]>=temp3)
--		judge4 <= 0;
--	else
--		judge4 <= 1;		
--end
	step4_jdg : process (phase3(16 downto 0), temp3)
	begin
		if (temp3 < 0) then
			judge4 <= 0;
		elsif (signed("00" & phase3(16 downto 0)) >= temp3) then
			judge4 <= 0;
		else
			judge4 <= 1;
		end if;
	end process;

--always@(posedge clk)begin
--	if(judge4==1)begin
--		temp4 <=temp3-5208;	
--		x4 <= x3 + y3/16;
--		y4 <= y3 - x3/16;		
--	end
--	else begin
--		temp4 <=temp3+5208;
--		x4 <= x3 - y3/16;
--		y4 <= y3 + x3/16;
--	end
--end
   step4 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge4 = 1) then
				temp4 <= temp3 - to_signed(5208, 19);
				x4 <= x3 + y3 / 8;
				y4 <= y3 - x3 / 8;
			else
				temp4 <= temp3 + to_signed(5208, 19);
				x4 <= x3 - y3 / 8;
				y4 <= y3 + x3 / 8;
			end if;
		end if;
	end process;


--///  step5 ////
--always@(phase4[16:0] or temp4)begin
--	if(temp4<0)
--		judge5 <= 0;
--	else if(phase4[16:0]>=temp4)
--		judge5 <= 0;
--	else
--		judge5 <= 1;		
--end
--
--always@(posedge clk)begin
--	if(judge5==1)begin
--		temp5 <=temp4-2606;	
--		x5 <= x4 + y4/32;
--		y5 <= y4 - x4/32;		
--	end
--	else begin
--		temp5 <=temp4+2606;
--		x5 <= x4 - y4/32;
--		y5 <= y4 + x4/32;
--	end
--end
	step5_jdg : process (phase4(16 downto 0), temp4)
	begin
		if (temp4 < 0) then
			judge5 <= 0;
		elsif (signed("00" & phase4(16 downto 0)) >= temp4) then
			judge5 <= 0;
		else
			judge5 <= 1;
		end if;
	end process;
   step5 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge5 = 1) then
				temp5 <= temp4 - to_signed(2606, 19);
				x5 <= x4 + y4 / 32;
				y5 <= y4 - x4 / 32;
			else
				temp5 <= temp4 + to_signed(2606, 19);
				x5 <= x4 - y4 / 32;
				y5 <= y4 + x4 / 32;
			end if;
		end if;
	end process;

--
--
--///  step6 ////
--always@(phase5[16:0] or temp5)begin
--	if(temp5<0)
--		judge6 <= 0;
--	else if(phase5[16:0]>=temp5)
--		judge6 <= 0;
--	else
--		judge6 <= 1;		
--end
--
--always@(posedge clk)begin
--	if(judge6==1)begin
--		temp6 <=temp5-1303;	
--		x6 <= x5 + y5/64;
--		y6 <= y5 - x5/64;		
--	end
--	else begin
--		temp6 <=temp5+1303;
--		x6 <= x5	- y5/64;
--		y6 <= y5 + x5/64;
--	end
--end
	step6_jdg : process (phase5(16 downto 0), temp5)
	begin
		if (temp5 < 0) then
			judge6 <= 0;
		elsif (signed("00" & phase5(16 downto 0)) >= temp5) then
			judge6 <= 0;
		else
			judge6 <= 1;
		end if;
	end process;
   step6 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge6 = 1) then
				temp6 <= temp5 - to_signed(1303, 19);
				x6 <= x5 + y5 / 64;
				y6 <= y5 - x5 / 64;
			else
				temp6 <= temp5 + to_signed(1303, 19);
				x6 <= x5 - y5 / 64;
				y6 <= y5 + x5 / 64;
			end if;
		end if;
	end process;
--
--
--///  step7 ////
--always@(phase6[16:0] or temp6)begin
--	if(temp6<0)
--		judge7 <= 0;
--	else if(phase6[16:0]>=temp6)
--		judge7 <= 0;
--	else
--		judge7 <= 1;		
--end
--
--always@(posedge clk)begin
--	if(judge7==1)begin
--		temp7 <=temp6-651;	
--		x7 <= x6 + y6/128;
--		y7 <= y6 - x6/128;		
--	end
--	else begin
--		temp7 <=temp6+651;
--		x7 <= x6	- y6/128;
--		y7 <= y6 + x6/128;
--	end
--end
	step7_jdg : process (phase6(16 downto 0), temp6)
	begin
		if (temp6 < 0) then
			judge7 <= 0;
		elsif (signed("00" & phase6(16 downto 0)) >= temp6) then
			judge7 <= 0;
		else
			judge7 <= 1;
		end if;
	end process;
   step7 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge7 = 1) then
				temp7 <= temp6 - to_signed(651, 19);
				x7 <= x6 + y6 / 128;
				y7 <= y6 - x6 / 128;
			else
				temp7 <= temp6 + to_signed(651, 19);
				x7 <= x6 - y6 / 128;
				y7 <= y6 + x6 / 128;
			end if;
		end if;
	end process;
--
--
--///  step8 ////
--always@(phase7[16:0] or temp7)begin
--	if(temp7<0)
--		judge8 <= 0;
--	else if(phase7[16:0]>=temp7)
--		judge8 <= 0;
--	else
--		judge8 <= 1;		
--end
--
--always@(posedge clk)begin
--	if(judge8==1)begin
--		temp8 <=temp7-325;	
--		x8 <= x7 + y7/256;
--		y8 <= y7 - x7/256;		
--	end
--	else begin
--		temp8 <=temp7+325;
--		x8 <= x7	- y7/256;
--		y8 <= y7 + x7/256;
--	end
--end
	step8_jdg : process (phase7(16 downto 0), temp7)
	begin
		if (temp7 < 0) then
			judge8 <= 0;
		elsif (signed("00" & phase7(16 downto 0)) >= temp7) then
			judge8 <= 0;
		else
			judge8 <= 1;
		end if;
	end process;
   step8 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge8 = 1) then
				temp8 <= temp7 - to_signed(325, 19);
				x8 <= x7 + y7 / 256;
				y8 <= y7 - x7 / 256;
			else
				temp8 <= temp7 + to_signed(325, 19);
				x8 <= x7 - y7 / 256;
				y8 <= y7 + x7 / 256;
			end if;
		end if;
	end process;


--///  step9 ////
--always@(phase8[16:0] or temp8)begin
--	if(temp8<0)
--		judge9 <= 0;
--	else if(phase8[16:0]>=temp8)
--		judge9 <= 0;
--	else
--		judge9 <= 1;		
--end
--
--always@(posedge clk)begin
--	if(judge9==1)begin
--		temp9 <=temp8-162;	
--		x9 <= x8 + y8/512;
--		y9 <= y8 - x8/512;		
--	end
--	else begin
--		temp9 <=temp8+162;
--		x9 <= x8	- y8/512;
--		y9 <= y8 + x8/512;
--	end
--end
	step9_jdg : process (phase8(16 downto 0), temp8)
	begin
		if (temp8 < 0) then
			judge9 <= 0;
		elsif (signed("00" & phase8(16 downto 0)) >= temp8) then
			judge9 <= 0;
		else
			judge9 <= 1;
		end if;
	end process;
   step9 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge9 = 1) then
				temp9 <= temp8 - to_signed(162, 19);
				x9 <= x8 + y8 / 512;
				y9 <= y8 - x8 / 512;
			else
				temp9 <= temp8 + to_signed(162, 19);
				x9 <= x8 - y8 / 512;
				y9 <= y8 + x8 / 512;
			end if;
		end if;
	end process;
--
--///  step10 ////
--always@(phase9[16:0] or temp9)begin
--	if(temp9<0)
--		judge10 <= 0;
--	else if(phase9[16:0]>=temp9)
--		judge10 <= 0;
--	else
--		judge10 <= 1;		
--end
--
--wire signed [18:0] shift10_x;
--wire signed [18:0] shift10_y;
--SHIFT10 INST10_x(x9,shift10_x);
--SHIFT10 INST10_y(y9,shift10_y);
--always@(posedge clk)begin
--	if(judge10==1)begin
--		temp10 <=temp9-81;	
--		x10 <= x9 + shift10_y;
--		y10 <= y9 - shift10_x;		
--	end
--	else begin
--		temp10 <=temp9+81;
--		x10 <= x9	- shift10_y;
--		y10 <= y9 + shift10_x;
--	end
--end
	step10_jdg : process (phase9(16 downto 0), temp9)
	begin
		if (temp9 < 0) then
			judge10 <= 0;
		elsif (signed("00" & phase9(16 downto 0)) >= temp9) then
			judge10 <= 0;
		else
			judge10 <= 1;
		end if;
	end process;
   step10 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge10 = 1) then
				temp10 <= temp9 - to_signed(81, 19);
				x10 <= x9 + SHIFT10(y9);
				y10 <= y9 - SHIFT10(x9);
			else
				temp10 <= temp9 + to_signed(81, 19);
				x10 <= x9 - SHIFT10(y9);
				y10 <= y9 + SHIFT10(x9);
			end if;
		end if;
	end process;
--
--///  step11 ////
--always@(phase10[16:0] or temp10)begin
--	if(temp10<0)
--		judge11 <= 0;
--	else if(phase10[16:0]>=temp10)
--		judge11 <= 0;
--	else
--		judge11 <= 1;		
--end
--
--wire signed [18:0] shift11_x;
--wire signed [18:0] shift11_y;
--SHIFT11 INST11_x(x10,shift11_x);
--SHIFT11 INST11_y(y10,shift11_y);
--
--always@(posedge clk)begin
--	if(judge11==1)begin
--		temp11 <=temp10-40;	
--		x11 <= x10 + shift11_y;
--		y11 <= y10 - shift11_x;		
--	end
--	else begin
--		temp11 <=temp10+40;
--		x11 <= x10	- shift11_y;
--		y11 <= y10 + shift11_x;
--	end
--end
	step11_jdg : process (phase10(16 downto 0), temp10)
	begin
		if (temp10 < 0) then
			judge11 <= 0;
		elsif (signed("00" & phase10(16 downto 0)) >= temp10) then
			judge11 <= 0;
		else
			judge11 <= 1;
		end if;
	end process;
   step11 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge11 = 1) then
				temp11 <= temp10 - to_signed(40, 19);
				x11 <= x10 + SHIFT11(y10);
				y11 <= y10 - SHIFT11(x10);
			else
				temp11 <= temp10 + to_signed(40, 19);
				x11 <= x10 - SHIFT11(y10);
				y11 <= y10 + SHIFT11(x10);
			end if;
		end if;
	end process;
--
--
--///  step12 ////
--always@(phase11[16:0] or temp11)begin
--	if(temp11<0)
--		judge12 <= 0;
--	else if(phase11[16:0]>=temp11)
--		judge12 <= 0;
--	else
--		judge12 <= 1;		
--end
--
--wire signed [18:0] shift12_x;
--wire signed [18:0] shift12_y;
--SHIFT12 INST12_x(x11,shift12_x);
--SHIFT12 INST12_y(y11,shift12_y);
--
--always@(posedge clk)begin
--	if(judge12==1)begin
--		temp12 <=temp11-20;	
--		x12 <= x11 + shift12_y;
--		y12 <= y11 - shift12_x;		
--	end
--	else begin
--		temp12 <=temp11+20;
--		x12 <= x11	- shift12_y;
--		y12 <= y11 + shift12_x;
--	end
--end
	step12_jdg : process (phase11(16 downto 0), temp11)
	begin
		if (temp11 < 0) then
			judge12 <= 0;
		elsif (signed("00" & phase11(16 downto 0)) >= temp11) then
			judge12 <= 0;
		else
			judge12 <= 1;
		end if;
	end process;
   step12 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge12 = 1) then
				temp12 <= temp11 - to_signed(20, 19);
				x12 <= x11 + SHIFT12(y11);
				y12 <= y11 - SHIFT12(x11);
			else
				temp12 <= temp11 + to_signed(20, 19);
				x12 <= x11 - SHIFT12(y11);
				y12 <= y11 + SHIFT12(x11);
			end if;
		end if;
	end process;

--///  step13 ////
--always@(phase12[16:0] or temp12)begin
--	if(temp12<0)
--		judge13 <= 0;
--	else if(phase12[16:0]>=temp12)
--		judge13 <= 0;
--	else
--		judge13 <= 1;		
--end
--
--wire signed [18:0] shift13_x;
--wire signed [18:0] shift13_y;
--SHIFT13 INST13_x(x12,shift13_x);
--SHIFT13 INST13_y(y12,shift13_y);
--always@(posedge clk)begin
--	if(judge13==1)begin
--		temp13 <=temp12-10;	
--		x13 <= x12 + shift13_y;
--		y13 <= y12 - shift13_x;		
--	end
--	else begin
--		temp13 <=temp12+10;
--		x13 <= x12	- shift13_y;
--		y13 <= y12 + shift13_x;
--	end
--end
	step13_jdg : process (phase12(16 downto 0), temp12)
	begin
		if (temp12 < 0) then
			judge13 <= 0;
		elsif (signed("00" & phase12(16 downto 0)) >= temp12) then
			judge13 <= 0;
		else
			judge13 <= 1;
		end if;
	end process;
   step13 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge13 = 1) then
				temp13 <= temp12 - to_signed(10, 19);
				x13 <= x12 + SHIFT13(y12);
				y13 <= y12 - SHIFT13(x12);
			else
				temp13 <= temp12 + to_signed(10, 19);
				x13 <= x12 - SHIFT13(y12);
				y13 <= y12 + SHIFT13(x12);
			end if;
		end if;
	end process;
--
--
--///  step14 ////
--always@(phase13[16:0] or temp13)begin
--	if(temp13<0)
--		judge14 <= 0;
--	else if(phase13[16:0]>=temp13)
--		judge14 <= 0;
--	else
--		judge14 <= 1;		
--end
--
--wire signed [18:0] shift14_x;
--wire signed [18:0] shift14_y;
--SHIFT14 INST14_x(x13,shift14_x);
--SHIFT14 INST14_y(y13,shift14_y);
--always@(posedge clk)begin
--	if(judge14==1)begin
--		temp14 <=temp13-5;	
--		x14 <= x13 + shift14_y;
--		y14 <= y13 - shift14_x;		
--	end
--	else begin
--		temp14 <=temp13+5;
--		x14 <= x13	- shift14_y;
--		y14 <= y13 + shift14_x;
--	end
--end
	step14_jdg : process (phase13(16 downto 0), temp13)
	begin
		if (temp13 < 0) then
			judge14 <= 0;
		elsif (signed("00" & phase13(16 downto 0)) >= temp13) then
			judge14 <= 0;
		else
			judge14 <= 1;
		end if;
	end process;
   step14 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge14 = 1) then
				temp14 <= temp13 - to_signed(5, 19);
				x14 <= x13 + SHIFT14(y13);
				y14 <= y13 - SHIFT14(x13);
			else
				temp14 <= temp13 + to_signed(5, 19);
				x14 <= x13 - SHIFT14(y13);
				y14 <= y13 + SHIFT14(x13);
			end if;
		end if;
	end process;
--
--
--///  step15 ////
--always@(phase14[16:0] or temp14)begin
--	if(temp14<0)
--		judge15 <= 0;
--	else if(phase14[16:0]>=temp14)
--		judge15 <= 0;
--	else
--		judge15 <= 1;		
--end
--
--wire signed [18:0] shift15_x;
--wire signed [18:0] shift15_y;
--SHIFT15 INST15_x(x14,shift15_x);
--SHIFT15 INST15_y(y14,shift15_y);
--always@(posedge clk)begin
--	if(judge15==1)begin
--		temp15 <=temp14-2;	
--		x15 <= x14 + shift15_y;
--		y15 <= y14 - shift15_x;		
--	end
--	else begin
--		temp15 <=temp14+2;
--		x15 <= x14	- shift15_y;
--		y15 <= y14 + shift15_x;
--	end
--end
	step15_jdg : process (phase14(16 downto 0), temp14)
	begin
		if (temp14 < 0) then
			judge15 <= 0;
		elsif (signed("00" & phase14(16 downto 0)) >= temp14) then
			judge15 <= 0;
		else
			judge15 <= 1;
		end if;
	end process;
   step15 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge15 = 1) then
				temp15 <= temp14 - to_signed(2, 19);
				x15 <= x14 + SHIFT15(y14);
				y15 <= y14 - SHIFT15(x14);
			else
				temp15 <= temp14 + to_signed(2, 19);
				x15 <= x14 - SHIFT15(y14);
				y15 <= y14 + SHIFT15(x14);
			end if;
		end if;
	end process;
--
--
--///  step16 ////
--always@(phase15[16:0] or temp15)begin
--	if(temp15<0)
--		judge16 <= 0;
--	else if(phase15[16:0]>=temp15)
--		judge16 <= 0;
--	else
--		judge16 <= 1;		
--end
--
--wire signed [18:0] shift16_x;
--wire signed [18:0] shift16_y;
--SHIFT16 INST16_x(x15,shift16_x);
--SHIFT16 INST16_y(y15,shift16_y);
--always@(posedge clk)begin
--	if(judge16==1)begin
--		temp16 <=temp15-1;	
--		x16 <= x15 + shift16_y;
--		y16 <= y15 - shift16_x;		
--	end
--	else begin
--		temp16 <=temp15+1;
--		x16 <= x15	- shift16_y;
--		y16 <= y15 + shift16_x;
--	end
--end
	step16_jdg : process (phase15(16 downto 0), temp15)
	begin
		if (temp15 < 0) then
			judge16 <= 0;
		elsif (signed("00" & phase15(16 downto 0)) >= temp15) then
			judge16 <= 0;
		else
			judge16 <= 1;
		end if;
	end process;
   step16 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge16 = 1) then
				temp16 <= temp15 - to_signed(1, 19);
				x16 <= x15 + SHIFT16(y15);
				y16 <= y15 - SHIFT16(x15);
			else
				temp16 <= temp15 + to_signed(1, 19);
				x16 <= x15 - SHIFT16(y15);
				y16 <= y15 + SHIFT16(x15);
			end if;
		end if;
	end process;
--
--
--///  step17 ////
--always@(phase16[16:0] or temp16)begin
--	if(temp16<0)
--		judge17 <= 0;
--	else if(phase16[16:0]>=temp16)
--		judge17 <= 0;
--	else
--		judge17 <= 1;		
--end
--
--wire signed [18:0] shift17_x;
--wire signed [18:0] shift17_y;
--SHIFT17 INST17_x(x16,shift17_x);
--SHIFT17 INST17_y(y16,shift17_y);
--
--always@(posedge clk)begin
--	if(judge17==1)begin
--		temp17 <=temp16-0;	
--		x17 <= x16 + shift17_y;
--		y17 <= y16 - shift17_x;		
--	end
--	else begin
--		temp17 <=temp16+0;
--		x17 <= x16	- shift17_y;
--		y17 <= y16 + shift17_x;
--	end
--end
	step17_jdg : process (phase16(16 downto 0), temp16)
	begin
		if (temp16 < 0) then
			judge17 <= 0;
		elsif (signed("00" & phase16(16 downto 0)) >= temp16) then
			judge17 <= 0;
		else
			judge17 <= 1;
		end if;
	end process;
   step17 : process (clk)
   begin
		if (rising_edge(clk)) then
			if (judge17 = 1) then
				--temp17 <= temp16 - to_signed(0, 19);
				x17 <= x16 + SHIFT17(y16);
				y17 <= y16 - SHIFT17(x16);
			else
				--temp17 <= temp16 + to_signed(0, 19);
				x17 <= x16 - SHIFT17(y16);
				y17 <= y16 + SHIFT17(x16);
			end if;
		end if;
	end process;
--
--
--///  step18 ////
--always@(posedge clk)begin
--	if(phase17[18:17]==0)begin	
--		cos <= x17/8;
--		sin <= y17/8;		
--	end
--	else if(phase17[18:17]==1)begin	
--		cos <= (-1)*y17/8;
--		sin <= x17/8;		
--	end
--	else if(phase17[18:17]==2)begin	
--		cos <= (-1)*x17/8;
--		sin <= (-1)*y17/8;		
--	end
--	else begin	
--		cos <= y17/8;
--		sin <= (-1)*x17/8;		
--	end
--end
   step18 : process (clk)
	variable var_cos : std_logic_vector(18 downto 0);
	variable var_sin : std_logic_vector(18 downto 0);
   begin
		if (rising_edge(clk)) then
			if (phase17(18 downto 17) = "00") then
				var_cos := std_logic_vector(x17 / 8);
				var_sin := std_logic_vector(y17 / 8);
			elsif (phase17(18 downto 17) = "01") then
				var_cos := std_logic_vector(-y17 / 8);
				var_sin := std_logic_vector(x17 / 8);
			elsif (phase17(18 downto 17) = "10") then
				var_cos := std_logic_vector(-x17 / 8);
				var_sin := std_logic_vector(-y17 / 8);
			else
				var_cos := std_logic_vector(y17 / 8);
				var_sin := std_logic_vector(-x17 / 8);
			end if;
			cos <= var_cos(15 downto 0);
			sin <= var_sin(15 downto 0);
		end if;
	end process;


end rtl;
