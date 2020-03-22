/*
-----MY_NCOモジュール--------
CORDICアルゴリズムによりサイン、コサインを生成するモジュール
(c) R. F. Architecture Co.,Ltd.

input clk　　　　　マスタークロック
output signed [15:0] SIN　16ビットのサイン出力
output signed [15:0] COS　16ビットのコサイン出力
input [31:0] frq    FTW（周波数）入力

*/
module MY_NCO(clk,frq,sin,cos);
input clk;
output signed [15:0] sin;
output signed [15:0] cos;
input [31:0] frq;

reg signed [15:0] sin;
reg signed [15:0] cos;



reg [31:0] phase32; 

reg judge0;
reg [18:0] phase0; 
reg signed [18:0] temp0;
reg signed [18:0] x0;
reg signed [18:0] y0;

reg judge1;
reg [18:0] phase1; 
reg signed [18:0] temp1;
reg signed [18:0] x1;
reg signed [18:0] y1;

reg judge2;
reg [18:0] phase2; 
reg signed [18:0] temp2;
reg signed [18:0] x2;
reg signed [18:0] y2;

reg judge3;
reg [18:0] phase3; 
reg signed [18:0] temp3;
reg signed [18:0] x3;
reg signed [18:0] y3;

reg judge4;
reg [18:0] phase4; 
reg signed [18:0] temp4;
reg signed [18:0] x4;
reg signed [18:0] y4;

reg judge5;
reg [18:0] phase5; 
reg signed [18:0] temp5;
reg signed [18:0] x5;
reg signed [18:0] y5;

reg judge6;
reg [18:0] phase6; 
reg signed [18:0] temp6;
reg signed [18:0] x6;
reg signed [18:0] y6;

reg judge7;
reg [18:0] phase7; 
reg signed [18:0] temp7;
reg signed [18:0] x7;
reg signed [18:0] y7;

reg judge8;
reg [18:0] phase8; 
reg signed [18:0] temp8;
reg signed [18:0] x8;
reg signed [18:0] y8;

reg judge9;
reg [18:0] phase9; 
reg signed [18:0] temp9;
reg signed [18:0] x9;
reg signed [18:0] y9;

reg judge10;
reg [18:0] phase10; 
reg signed [18:0] temp10;
reg signed [18:0] x10;
reg signed [18:0] y10;

reg judge11;
reg [18:0] phase11; 
reg signed [18:0] temp11;
reg signed [18:0] x11;
reg signed [18:0] y11;

reg judge12;
reg [18:0] phase12; 
reg signed [18:0] temp12;
reg signed [18:0] x12;
reg signed [18:0] y12;

reg judge13;
reg [18:0] phase13; 
reg signed [18:0] temp13;
reg signed [18:0] x13;
reg signed [18:0] y13;

reg judge14;
reg [18:0] phase14; 
reg signed [18:0] temp14;
reg signed [18:0] x14;
reg signed [18:0] y14;

reg judge15;
reg [18:0] phase15; 
reg signed [18:0] temp15;
reg signed [18:0] x15;
reg signed [18:0] y15;

reg judge16;
reg [18:0] phase16; 
reg signed [18:0] temp16;
reg signed [18:0] x16;
reg signed [18:0] y16;

reg judge17;
reg [18:0] phase17; 
reg signed [18:0] temp17;
reg signed [18:0] x17;
reg signed [18:0] y17;

reg [18:0] phase18; 

always@(posedge clk)begin
	phase32 <= 	phase32 + frq;	
	phase0 <= phase32[31:13];
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
end

///  step0 ////
always@(posedge clk)begin
	temp0 <= 	65536;	
	x0 <= 131072;
	y0 <= 131072;
end

///  step1 ////
always@(phase0[16:0] or temp0)begin
	if(temp0<0)
		judge1 <= 0;
	else if(phase0[16:0]>=temp0)
		judge1 <= 0;
	else
		judge1 <= 1;		
end

always@(posedge clk)begin
	if(judge1==1)begin
		temp1 <=temp0-38688;	
		x1 <= x0 + y0/2;
		y1 <= y0 - x0/2;		
	end
	else begin
		temp1 <=temp0+38688;
		x1 <= x0 - y0/2;
		y1 <= y0 + x0/2;
	end
end


///  step2 ////
always@(phase1[16:0] or temp1)begin
	if(temp1<0)
		judge2 <= 0;
	else if(phase1[16:0]>=temp1)
		judge2 <= 0;
	else
		judge2 <= 1;		
end

always@(posedge clk)begin
	if(judge2==1)begin
		temp2 <=temp1-20441;	
		x2 <= x1 + y1/4;
		y2 <= y1 - x1/4;		
	end
	else begin
		temp2 <=temp1+20441;
		x2 <= x1 - y1/4;
		y2 <= y1 + x1/4;
	end
end

///  step3 ////
always@(phase2[16:0] or temp2)begin
	if(temp2<0)
		judge3 <= 0;
	else if(phase2[16:0]>=temp2)
		judge3 <= 0;
	else
		judge3 <= 1;		
end

always@(posedge clk)begin
	if(judge3==1)begin
		temp3 <=temp2-10376;	
		x3 <= x2 + y2/8;
		y3 <= y2 - x2/8;		
	end
	else begin
		temp3 <=temp2+10376;
		x3 <= x2 - y2/8;
		y3 <= y2 + x2/8;
	end
end

///  step4 ////
always@(phase3[16:0] or temp3)begin
	if(temp3<0)
		judge4 <= 0;
	else if(phase3[16:0]>=temp3)
		judge4 <= 0;
	else
		judge4 <= 1;		
end

always@(posedge clk)begin
	if(judge4==1)begin
		temp4 <=temp3-5208;	
		x4 <= x3 + y3/16;
		y4 <= y3 - x3/16;		
	end
	else begin
		temp4 <=temp3+5208;
		x4 <= x3 - y3/16;
		y4 <= y3 + x3/16;
	end
end


///  step5 ////
always@(phase4[16:0] or temp4)begin
	if(temp4<0)
		judge5 <= 0;
	else if(phase4[16:0]>=temp4)
		judge5 <= 0;
	else
		judge5 <= 1;		
end

always@(posedge clk)begin
	if(judge5==1)begin
		temp5 <=temp4-2606;	
		x5 <= x4 + y4/32;
		y5 <= y4 - x4/32;		
	end
	else begin
		temp5 <=temp4+2606;
		x5 <= x4 - y4/32;
		y5 <= y4 + x4/32;
	end
end


///  step6 ////
always@(phase5[16:0] or temp5)begin
	if(temp5<0)
		judge6 <= 0;
	else if(phase5[16:0]>=temp5)
		judge6 <= 0;
	else
		judge6 <= 1;		
end

always@(posedge clk)begin
	if(judge6==1)begin
		temp6 <=temp5-1303;	
		x6 <= x5 + y5/64;
		y6 <= y5 - x5/64;		
	end
	else begin
		temp6 <=temp5+1303;
		x6 <= x5	- y5/64;
		y6 <= y5 + x5/64;
	end
end


///  step7 ////
always@(phase6[16:0] or temp6)begin
	if(temp6<0)
		judge7 <= 0;
	else if(phase6[16:0]>=temp6)
		judge7 <= 0;
	else
		judge7 <= 1;		
end

always@(posedge clk)begin
	if(judge7==1)begin
		temp7 <=temp6-651;	
		x7 <= x6 + y6/128;
		y7 <= y6 - x6/128;		
	end
	else begin
		temp7 <=temp6+651;
		x7 <= x6	- y6/128;
		y7 <= y6 + x6/128;
	end
end


///  step8 ////
always@(phase7[16:0] or temp7)begin
	if(temp7<0)
		judge8 <= 0;
	else if(phase7[16:0]>=temp7)
		judge8 <= 0;
	else
		judge8 <= 1;		
end

always@(posedge clk)begin
	if(judge8==1)begin
		temp8 <=temp7-325;	
		x8 <= x7 + y7/256;
		y8 <= y7 - x7/256;		
	end
	else begin
		temp8 <=temp7+325;
		x8 <= x7	- y7/256;
		y8 <= y7 + x7/256;
	end
end


///  step9 ////
always@(phase8[16:0] or temp8)begin
	if(temp8<0)
		judge9 <= 0;
	else if(phase8[16:0]>=temp8)
		judge9 <= 0;
	else
		judge9 <= 1;		
end

always@(posedge clk)begin
	if(judge9==1)begin
		temp9 <=temp8-162;	
		x9 <= x8 + y8/512;
		y9 <= y8 - x8/512;		
	end
	else begin
		temp9 <=temp8+162;
		x9 <= x8	- y8/512;
		y9 <= y8 + x8/512;
	end
end

///  step10 ////
always@(phase9[16:0] or temp9)begin
	if(temp9<0)
		judge10 <= 0;
	else if(phase9[16:0]>=temp9)
		judge10 <= 0;
	else
		judge10 <= 1;		
end

wire signed [18:0] shift10_x;
wire signed [18:0] shift10_y;
SHIFT10 INST10_x(x9,shift10_x);
SHIFT10 INST10_y(y9,shift10_y);
always@(posedge clk)begin
	if(judge10==1)begin
		temp10 <=temp9-81;	
		x10 <= x9 + shift10_y;
		y10 <= y9 - shift10_x;		
	end
	else begin
		temp10 <=temp9+81;
		x10 <= x9	- shift10_y;
		y10 <= y9 + shift10_x;
	end
end

///  step11 ////
always@(phase10[16:0] or temp10)begin
	if(temp10<0)
		judge11 <= 0;
	else if(phase10[16:0]>=temp10)
		judge11 <= 0;
	else
		judge11 <= 1;		
end

wire signed [18:0] shift11_x;
wire signed [18:0] shift11_y;
SHIFT11 INST11_x(x10,shift11_x);
SHIFT11 INST11_y(y10,shift11_y);

always@(posedge clk)begin
	if(judge11==1)begin
		temp11 <=temp10-40;	
		x11 <= x10 + shift11_y;
		y11 <= y10 - shift11_x;		
	end
	else begin
		temp11 <=temp10+40;
		x11 <= x10	- shift11_y;
		y11 <= y10 + shift11_x;
	end
end


///  step12 ////
always@(phase11[16:0] or temp11)begin
	if(temp11<0)
		judge12 <= 0;
	else if(phase11[16:0]>=temp11)
		judge12 <= 0;
	else
		judge12 <= 1;		
end

wire signed [18:0] shift12_x;
wire signed [18:0] shift12_y;
SHIFT12 INST12_x(x11,shift12_x);
SHIFT12 INST12_y(y11,shift12_y);

always@(posedge clk)begin
	if(judge12==1)begin
		temp12 <=temp11-20;	
		x12 <= x11 + shift12_y;
		y12 <= y11 - shift12_x;		
	end
	else begin
		temp12 <=temp11+20;
		x12 <= x11	- shift12_y;
		y12 <= y11 + shift12_x;
	end
end


///  step13 ////
always@(phase12[16:0] or temp12)begin
	if(temp12<0)
		judge13 <= 0;
	else if(phase12[16:0]>=temp12)
		judge13 <= 0;
	else
		judge13 <= 1;		
end

wire signed [18:0] shift13_x;
wire signed [18:0] shift13_y;
SHIFT13 INST13_x(x12,shift13_x);
SHIFT13 INST13_y(y12,shift13_y);
always@(posedge clk)begin
	if(judge13==1)begin
		temp13 <=temp12-10;	
		x13 <= x12 + shift13_y;
		y13 <= y12 - shift13_x;		
	end
	else begin
		temp13 <=temp12+10;
		x13 <= x12	- shift13_y;
		y13 <= y12 + shift13_x;
	end
end


///  step14 ////
always@(phase13[16:0] or temp13)begin
	if(temp13<0)
		judge14 <= 0;
	else if(phase13[16:0]>=temp13)
		judge14 <= 0;
	else
		judge14 <= 1;		
end

wire signed [18:0] shift14_x;
wire signed [18:0] shift14_y;
SHIFT14 INST14_x(x13,shift14_x);
SHIFT14 INST14_y(y13,shift14_y);
always@(posedge clk)begin
	if(judge14==1)begin
		temp14 <=temp13-5;	
		x14 <= x13 + shift14_y;
		y14 <= y13 - shift14_x;		
	end
	else begin
		temp14 <=temp13+5;
		x14 <= x13	- shift14_y;
		y14 <= y13 + shift14_x;
	end
end


///  step15 ////
always@(phase14[16:0] or temp14)begin
	if(temp14<0)
		judge15 <= 0;
	else if(phase14[16:0]>=temp14)
		judge15 <= 0;
	else
		judge15 <= 1;		
end

wire signed [18:0] shift15_x;
wire signed [18:0] shift15_y;
SHIFT15 INST15_x(x14,shift15_x);
SHIFT15 INST15_y(y14,shift15_y);
always@(posedge clk)begin
	if(judge15==1)begin
		temp15 <=temp14-2;	
		x15 <= x14 + shift15_y;
		y15 <= y14 - shift15_x;		
	end
	else begin
		temp15 <=temp14+2;
		x15 <= x14	- shift15_y;
		y15 <= y14 + shift15_x;
	end
end


///  step16 ////
always@(phase15[16:0] or temp15)begin
	if(temp15<0)
		judge16 <= 0;
	else if(phase15[16:0]>=temp15)
		judge16 <= 0;
	else
		judge16 <= 1;		
end

wire signed [18:0] shift16_x;
wire signed [18:0] shift16_y;
SHIFT16 INST16_x(x15,shift16_x);
SHIFT16 INST16_y(y15,shift16_y);
always@(posedge clk)begin
	if(judge16==1)begin
		temp16 <=temp15-1;	
		x16 <= x15 + shift16_y;
		y16 <= y15 - shift16_x;		
	end
	else begin
		temp16 <=temp15+1;
		x16 <= x15	- shift16_y;
		y16 <= y15 + shift16_x;
	end
end


///  step17 ////
always@(phase16[16:0] or temp16)begin
	if(temp16<0)
		judge17 <= 0;
	else if(phase16[16:0]>=temp16)
		judge17 <= 0;
	else
		judge17 <= 1;		
end

wire signed [18:0] shift17_x;
wire signed [18:0] shift17_y;
SHIFT17 INST17_x(x16,shift17_x);
SHIFT17 INST17_y(y16,shift17_y);

always@(posedge clk)begin
	if(judge17==1)begin
		temp17 <=temp16-0;	
		x17 <= x16 + shift17_y;
		y17 <= y16 - shift17_x;		
	end
	else begin
		temp17 <=temp16+0;
		x17 <= x16	- shift17_y;
		y17 <= y16 + shift17_x;
	end
end


///  step18 ////
always@(posedge clk)begin
	if(phase17[18:17]==0)begin	
		cos <= x17/8;
		sin <= y17/8;		
	end
	else if(phase17[18:17]==1)begin	
		cos <= (-1)*y17/8;
		sin <= x17/8;		
	end
	else if(phase17[18:17]==2)begin	
		cos <= (-1)*x17/8;
		sin <= (-1)*y17/8;		
	end
	else begin	
		cos <= y17/8;
		sin <= (-1)*x17/8;		
	end
end


endmodule

module SHIFT10(indata,outdata);
input [18:0] indata;
output [18:0] outdata;

reg [18:0] outdata;

always@(indata)begin
	if(indata[18])
		outdata <= {10'h3FF,indata[18:10]};
	else
		outdata <= {10'h0,indata[18:10]};		
end

endmodule

module SHIFT11(indata,outdata);
input [18:0] indata;
output [18:0] outdata;

reg [18:0] outdata;

always@(indata)begin
	if(indata[18])
		outdata <= {11'h7FF,indata[18:11]};
	else
		outdata <= {11'h0,indata[18:11]};		
end

endmodule

module SHIFT12(indata,outdata);
input [18:0] indata;
output [18:0] outdata;

reg [18:0] outdata;

always@(indata)begin
	if(indata[18])
		outdata <= {12'hFFF,indata[18:12]};
	else
		outdata <= {12'h0,indata[18:12]};		
end

endmodule

module SHIFT13(indata,outdata);
input [18:0] indata;
output [18:0] outdata;

reg [18:0] outdata;

always@(indata)begin
	if(indata[18])
		outdata <= {13'h1FFF,indata[18:13]};
	else
		outdata <= {13'h0,indata[18:13]};		
end

endmodule


module SHIFT14(indata,outdata);
input [18:0] indata;
output [18:0] outdata;

reg [18:0] outdata;

always@(indata)begin
	if(indata[18])
		outdata <= {14'h3FFF,indata[18:14]};
	else
		outdata <= {14'h0,indata[18:14]};		
end

endmodule

module SHIFT15(indata,outdata);
input [18:0] indata;
output [18:0] outdata;

reg [18:0] outdata;

always@(indata)begin
	if(indata[18])
		outdata <= {15'h7FFF,indata[18:15]};
	else
		outdata <= {15'h0,indata[18:15]};		
end

endmodule

module SHIFT16(indata,outdata);
input [18:0] indata;
output [18:0] outdata;

reg [18:0] outdata;

always@(indata)begin
	if(indata[18])
		outdata <= {16'hFFFF,indata[18:16]};
	else
		outdata <= {16'h0,indata[18:16]};		
end

endmodule

module SHIFT17(indata,outdata);
input [18:0] indata;
output [18:0] outdata;

reg [18:0] outdata;

always@(indata)begin
	if(indata[18])
		outdata <= {17'h1FFFF,indata[18:17]};
	else
		outdata <= {17'h0,indata[18:17]};		
end

endmodule


module SHIFT18(indata,outdata);
input [18:0] indata;
output [18:0] outdata;

reg [18:0] outdata;

always@(indata)begin
	if(indata[18])
		outdata <= {18'h3FFFF,indata[18:18]};
	else
		outdata <= {18'h0,indata[18:18]};		
end

endmodule


