/*
-----lpf_firモジュール--------

40Mspsを5Mspsに変換する前に、2.5MHz以上の成分を除去する、FIRによるLPFフィルタ
マスタークロックは80MHzであるが、このフィルタは40Mspsで動作する

input clk　　　　　マスタークロック
input signed [11:0] indata　入力データ
output signed [15:0] outdata　出力データ
*/
module lpf_fir(clk,indata,outdata);
input clk;
input signed [11:0] indata;
output signed [15:0] outdata; 

reg signed [15:0] outdata; 

wire signed [11:0] cof1;
wire signed [11:0] cof2;
wire signed [11:0] cof3;
wire signed [11:0] cof4;
wire signed [11:0] cof5;
wire signed [11:0] cof6;
wire signed [11:0] cof7;
wire signed [11:0] cof8;
wire signed [11:0] cof9;
wire signed [11:0] cof10;
wire signed [11:0] cof11;
wire signed [11:0] cof12;
wire signed [11:0] cof13;
wire signed [11:0] cof14;
wire signed [11:0] cof15;
wire signed [11:0] cof16;
wire signed [11:0] cof17;
wire signed [11:0] cof18;
wire signed [11:0] cof19;
wire signed [11:0] cof20;
wire signed [11:0] cof21;
wire signed [11:0] cof22;
wire signed [11:0] cof23;
wire signed [11:0] cof24;
wire signed [11:0] cof25;
wire signed [11:0] cof26;
wire signed [11:0] cof27;
wire signed [11:0] cof28;


assign cof1=-190;
assign cof2=-163;
assign cof3=-114;
assign cof4=-43;
assign cof5=47;
assign cof6=153;
assign cof7=270;
assign cof8=392;
assign cof9=514;
assign cof10=628;
assign cof11=729;
assign cof12=810;
assign cof13=867;
assign cof14=896;
assign cof15=896;
assign cof16=867;
assign cof17=810;
assign cof18=729;
assign cof19=628;
assign cof20=514;
assign cof21=392;
assign cof22=270;
assign cof23=153;
assign cof24=47;
assign cof25=-43;
assign cof26=-114;
assign cof27=-163;
assign cof28=-190;




reg signed [11:0] indata1;
reg signed [11:0] indata2;
reg signed [11:0] indata3;
reg signed [11:0] indata4;
reg signed [11:0] indata5;
reg signed [11:0] indata6;
reg signed [11:0] indata7;
reg signed [11:0] indata8;
reg signed [11:0] indata9;
reg signed [11:0] indata10;
reg signed [11:0] indata11;
reg signed [11:0] indata12;
reg signed [11:0] indata13;
reg signed [11:0] indata14;
reg signed [11:0] indata15;
reg signed [11:0] indata16;
reg signed [11:0] indata17;
reg signed [11:0] indata18;
reg signed [11:0] indata19;
reg signed [11:0] indata20;
reg signed [11:0] indata21;
reg signed [11:0] indata22;
reg signed [11:0] indata23;
reg signed [11:0] indata24;
reg signed [11:0] indata25;
reg signed [11:0] indata26;
reg signed [11:0] indata27;
reg signed [11:0] indata28;
reg toggle;

reg signed [24:0] multi1;
reg signed [24:0] multi2;
reg signed [24:0] multi3;
reg signed [24:0] multi4;
reg signed [24:0] multi5;
reg signed [24:0] multi6;
reg signed [24:0] multi7;
reg signed [24:0] multi8;
reg signed [24:0] multi9;
reg signed [24:0] multi10;
reg signed [24:0] multi11;
reg signed [24:0] multi12;
reg signed [24:0] multi13;
reg signed [24:0] multi14;

reg signed [25:0] sum1;
reg signed [25:0] sum2;

reg signed [25:0] pre_out;

always@(posedge clk)begin
	toggle <= ~toggle;
end

always@(posedge clk)begin
	if(toggle)begin
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
	end
	else begin
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
	end
end



always@(posedge clk)begin
	if(!toggle)begin
		multi1 <= indata1*cof1;
		multi2 <= indata3*cof3;
		multi3 <= indata5*cof5;
		multi4 <= indata7*cof7;
		multi5 <= indata9*cof9;	
		multi6 <= indata11*cof11;
		multi7 <= indata13*cof13;
		multi8 <= indata15*cof15;
		multi9 <= indata17*cof17;
		multi10 <= indata19*cof19;
		multi11 <= indata21*cof21;
		multi12 <= indata23*cof23;
		multi13 <= indata25*cof25;
		multi14 <= indata27*cof27;
	end
	else begin
		multi1 <= indata2*cof2;
		multi2 <= indata4*cof4;
		multi3 <= indata6*cof6;
		multi4 <= indata8*cof8;
		multi5 <= indata10*cof10;	
		multi6 <= indata12*cof12;
		multi7 <= indata14*cof14;
		multi8 <= indata16*cof16;
		multi9 <= indata18*cof18;
		multi10 <= indata20*cof20;
		multi11 <= indata22*cof22;
		multi12 <= indata24*cof24;
		multi13 <= indata26*cof26;
		multi14 <= indata28*cof28;
	end
end



always@(posedge clk)begin
	sum1 <= multi1 + multi2 + multi3 + multi4 + multi5+multi6+multi7;
	sum2 <= multi8 + multi9 + multi10 + multi11 + multi12 + multi13 + multi14;
end

always@(posedge clk)begin
	if(!toggle)
		pre_out <= sum1 + sum2;
	else
		pre_out <= pre_out+sum1 + sum2;
end

always@(posedge clk)begin
	if(toggle)
		outdata <= pre_out[23:8];
	else
		outdata <= outdata;		
end

endmodule


/*
-----bpf_firモジュール--------

75kHz～325kHzを通過させる、FIRによるBPFフィルタ
マスタークロックは80MHzであるが、このフィルタは5Mspsで動作する

input clk　　　　　マスタークロック
input signed [15:0] indata　入力データ
output signed [17:0] outdata　出力データ
*/
module bpf_fir(clk,indata,outdata);
input clk;
input signed [15:0] indata;
output signed [17:0] outdata; 

reg signed [17:0] outdata; 

wire signed [11:0] cof1;
wire signed [11:0] cof2;
wire signed [11:0] cof3;
wire signed [11:0] cof4;
wire signed [11:0] cof5;
wire signed [11:0] cof6;
wire signed [11:0] cof7;
wire signed [11:0] cof8;
wire signed [11:0] cof9;
wire signed [11:0] cof10;
wire signed [11:0] cof11;
wire signed [11:0] cof12;
wire signed [11:0] cof13;
wire signed [11:0] cof14;
wire signed [11:0] cof15;
wire signed [11:0] cof16;
wire signed [11:0] cof17;
wire signed [11:0] cof18;
wire signed [11:0] cof19;
wire signed [11:0] cof20;
wire signed [11:0] cof21;
wire signed [11:0] cof22;
wire signed [11:0] cof23;
wire signed [11:0] cof24;
wire signed [11:0] cof25;
wire signed [11:0] cof26;
wire signed [11:0] cof27;
wire signed [11:0] cof28;
wire signed [11:0] cof29;
wire signed [11:0] cof30;
wire signed [11:0] cof31;
wire signed [11:0] cof32;



assign cof1=-823;
assign cof2=-776;
assign cof3=-614;
assign cof4=-341;
assign cof5=21;
assign cof6=436;
assign cof7=856;
assign cof8=1230;
assign cof9=1510;
assign cof10=1660;
assign cof11=1660;
assign cof12=1510;
assign cof13=1230;
assign cof14=856;
assign cof15=436;
assign cof16=21;
assign cof17=-341;
assign cof18=-614;
assign cof19=-776;
assign cof20=-823;
assign cof21=0;
assign cof22=0;
assign cof23=0;
assign cof24=0;
assign cof25=0;
assign cof26=0;
assign cof27=0;
assign cof28=0;
assign cof29=0;
assign cof30=0;
assign cof31=0;
assign cof32=0;



reg signed [15:0] indata1;
reg signed [15:0] indata2;
reg signed [15:0] indata3;
reg signed [15:0] indata4;
reg signed [15:0] indata5;
reg signed [15:0] indata6;
reg signed [15:0] indata7;
reg signed [15:0] indata8;
reg signed [15:0] indata9;
reg signed [15:0] indata10;
reg signed [15:0] indata11;
reg signed [15:0] indata12;
reg signed [15:0] indata13;
reg signed [15:0] indata14;
reg signed [15:0] indata15;
reg signed [15:0] indata16;
reg signed [15:0] indata17;
reg signed [15:0] indata18;
reg signed [15:0] indata19;
reg signed [15:0] indata20;
reg signed [15:0] indata21;
reg signed [15:0] indata22;
reg signed [15:0] indata23;
reg signed [15:0] indata24;
reg signed [15:0] indata25;
reg signed [15:0] indata26;
reg signed [15:0] indata27;
reg signed [15:0] indata28;
reg signed [15:0] indata29;
reg signed [15:0] indata30;
reg signed [15:0] indata31;
reg signed [15:0] indata32;
reg [3:0] toggle;

reg signed [15:0] sel_indata1;
reg signed [11:0] sel_cof1;
reg signed [15:0] sel_indata2;
reg signed [11:0] sel_cof2;
reg signed [28:0] multi1;
reg signed [28:0] multi2;
reg signed [31:0] pre_out;

always@(posedge clk)begin
	toggle <= toggle+4'd1;
end

always@(posedge clk)begin
	if(toggle==15)begin
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
		indata29 <= indata28;
		indata30 <= indata29;
		indata31 <= indata30;
		indata32 <= indata31;
	end
	else begin
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
		indata29 <= indata29;
		indata30 <= indata30;
		indata31 <= indata31;
		indata32 <= indata32;
	end
end




always@(posedge clk)begin
	if(toggle==0)begin
		sel_indata1 <= indata1;
		sel_indata2 <= indata17;
		sel_cof1 <= cof1;
		sel_cof2 <= cof17;
	end
	else if(toggle==1)begin
		sel_indata1 <= indata2;
		sel_indata2 <= indata18;
		sel_cof1 <= cof2;
		sel_cof2 <= cof18;
	end
	else if(toggle==2)begin
		sel_indata1 <= indata3;
		sel_indata2 <= indata19;
		sel_cof1 <= cof3;
		sel_cof2 <= cof19;
	end
	else if(toggle==3)begin
		sel_indata1 <= indata4;
		sel_indata2 <= indata20;
		sel_cof1 <= cof4;
		sel_cof2 <= cof20;
	end
	else if(toggle==4)begin
		sel_indata1 <= indata5;
		sel_indata2 <= indata21;
		sel_cof1 <= cof5;
		sel_cof2 <= cof21;
	end
	else if(toggle==5)begin
		sel_indata1 <= indata6;
		sel_indata2 <= indata22;
		sel_cof1 <= cof6;
		sel_cof2 <= cof22;
	end
	else if(toggle==6)begin
		sel_indata1 <= indata7;
		sel_indata2 <= indata23;
		sel_cof1 <= cof7;
		sel_cof2 <= cof23;
	end
	else if(toggle==7)begin
		sel_indata1 <= indata8;
		sel_indata2 <= indata24;
		sel_cof1 <= cof8;
		sel_cof2 <= cof24;
	end
	else if(toggle==8)begin
		sel_indata1 <= indata9;
		sel_indata2 <= indata25;
		sel_cof1 <= cof9;
		sel_cof2 <= cof25;
	end
	else if(toggle==9)begin
		sel_indata1 <= indata10;
		sel_indata2 <= indata26;
		sel_cof1 <= cof10;
		sel_cof2 <= cof26;
	end
	else if(toggle==10)begin
		sel_indata1 <= indata11;
		sel_indata2 <= indata27;
		sel_cof1 <= cof11;
		sel_cof2 <= cof27;
	end
	else if(toggle==11)begin
		sel_indata1 <= indata12;
		sel_indata2 <= indata28;
		sel_cof1 <= cof12;
		sel_cof2 <= cof28;
	end
	else if(toggle==12)begin
		sel_indata1 <= indata13;
		sel_indata2 <= indata29;
		sel_cof1 <= cof13;
		sel_cof2 <= cof29;
	end
	else if(toggle==13)begin
		sel_indata1 <= indata14;
		sel_indata2 <= indata30;
		sel_cof1 <= cof14;
		sel_cof2 <= cof30;
	end
	else if(toggle==14)begin
		sel_indata1 <= indata15;
		sel_indata2 <= indata31;
		sel_cof1 <= cof15;
		sel_cof2 <= cof31;
	end
	else begin
		sel_indata1 <= indata16;
		sel_indata2 <= indata32;
		sel_cof1 <= cof16;
		sel_cof2 <= cof32;
	end
end

always@(posedge clk)begin
	multi1 <= sel_indata1*sel_cof1;
	multi2 <= sel_indata2*sel_cof2;
end


always@(posedge clk)begin
	if(toggle==2)
		pre_out <= multi1 + multi2;
	else
		pre_out <= pre_out + multi1 + multi2;
end

always@(posedge clk)begin
	if(toggle==2)
		outdata <= pre_out[28:11];
	else
		outdata <= outdata;		
end

endmodule
