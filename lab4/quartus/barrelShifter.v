//`include "mux2.v"

module barrelShifter (outData,inData,shift);

	input [31:0] inData,shift;
	output [31:0] outData;
	
	wire [31:0] data0,data1,data2,data3,data4,data5;
	
	//wire [31:0] finalData;

	
	/*
	genvar i;
	generate
		for(i=0; i<32; i=i+1) begin:BARREL
			//if (shift[0]==1'b1) begin
				if (i<1) mux2 BARREL (.din_0(inData[i]),.din_1(1'b0),.sel(shift[0]),.mux_out(data0[i]));
				else mux2 BARREL (.din_0(inData[i]),.din_1(inData[i-1]),.sel(shift[0]),.mux_out(data0[i]));
			//end
			//else if (shift[1]==1'b1)begin
				if (i<2) mux2 SHIFT1 (.din_0(data0[i]),.din_1(1'b0),.sel(shift[1]),.mux_out(data1[i]));
				else mux2 SHIFT1 (.din_0(data0[i]),.din_1(data0[i-2]),.sel(shift[1]),.mux_out(data1[i]));
			//end	
			//else if (shift[3]==1'b1)begin
				if (i<4) mux2 SHIFT2 (.din_0(data1[i]),.din_1(1'b0),.sel(shift[2]),.mux_out(data2[i]));
				else mux2 SHIFT2 (.din_0(data1[i]),.din_1(data1[i-4]),.sel(shift[2]),.mux_out(data2[i]));
			//end	
			//else if (shift[4]==1'b1)begin
				if (i<8) mux2 SHIFT3 (.din_0(data2[i]),.din_1(1'b0),.sel(shift[3]),.mux_out(data3[i]));
				else mux2 SHIFT3 (.din_0(data2[i]),.din_1(data2[i-8]),.sel(shift[3]),.mux_out(data3[i]));
			//end
			//else if (shift[5]==1'b1)begin
				if (i<16) mux2 SHIFT4 (.din_0(data3[i]),.din_1(1'b0),.sel(shift[4]),.mux_out(data4[i]));
				else mux2 SHIFT4 (.din_0(data3[i]),.din_1(data3[i-16]),.sel(shift[4]),.mux_out(data4[i]));
			//end	
			//else if (shift[6]==1'b1)begin
				if (i<32) mux2 SHIFT5 (.din_0(data4[i]),.din_1(1'b0),.sel(shift[5]),.mux_out(data5[i]));
				else mux2 SHIFT5 (.din_0(data4[i]),.din_1(data4[i-32]),.sel(shift[5]),.mux_out(data5[i]));
			//end	
		end
	endgenerate
	*/
	
	genvar a;
	generate
		for (a=0;a<1;a=a+1) begin :BARREL
			mux2_1 BARREL (.din_0(inData[a]),.din_1(1'b0),.sel(shift[0]),.mux_out(data0[a]));
		end
	endgenerate
	
	genvar b;
	generate
		for (b=1;b<32;b=b+1) begin:BARREL1
			mux2_1 BARREL (.din_0(inData[b]),.din_1(inData[b-1]),.sel(shift[0]),.mux_out(data0[b]));
		end
	endgenerate
	
	genvar c;
	generate
		for (c=0;c<2;c=c+1) begin:BARREL2
			mux2_1 BARREL1 (.din_0(data0[c]),.din_1(1'b0),.sel(shift[1]),.mux_out(data1[c]));
		end
	endgenerate
	
	genvar d;
	generate
		for (d=2;d<32;d=d+1) begin:BARREL3
			mux2_1 BARREL1 (.din_0(data0[d]),.din_1(data0[d-2]),.sel(shift[1]),.mux_out(data1[d]));
		end
	endgenerate
	
	genvar e;
	generate
		for (e=0;e<4;e=e+1) begin:BARREL4
			mux2_1 BARREL2 (.din_0(data1[e]),.din_1(1'b0),.sel(shift[2]),.mux_out(data2[e]));
		end
	endgenerate
	
	genvar f;
	generate
		for (f=4;f<32;f=f+1) begin:BARREL5
			mux2_1 BARREL2 (.din_0(data1[f]),.din_1(data1[f-4]),.sel(shift[2]),.mux_out(data2[f]));
		end
	endgenerate
	
	genvar g;
	generate
		for (g=0;g<8;g=g+1) begin:BARREL6
			mux2_1 BARREL3 (.din_0(data2[g]),.din_1(1'b0),.sel(shift[3]),.mux_out(data3[g]));
		end
	endgenerate
	
	genvar h;
	generate
		for (h=8;h<32;h=h+1) begin:BARREL7
			mux2_1 BARREL3 (.din_0(data2[h]),.din_1(data2[h-8]),.sel(shift[3]),.mux_out(data3[h]));
		end
	endgenerate
	
	genvar i;
	generate
		for (i=0;i<16;i=i+1) begin:BARREL8
			mux2_1 BARREL4 (.din_0(data3[i]),.din_1(1'b0),.sel(shift[4]),.mux_out(data4[i]));
		end
	endgenerate
	
	genvar j;
	generate
		for (j=16;j<32;j=j+1) begin:BARREL9
			mux2_1 BARREL4 (.din_0(data3[j]),.din_1(data3[j-16]),.sel(shift[4]),.mux_out(data4[j]));
		end
	endgenerate
	
	genvar l;
	generate
		for (l=0;l<32;l=l+1) begin:BARREL10
			mux2_1 BARREL5 (.din_0(data4[l]),.din_1(1'b0),.sel(shift[5]),.mux_out(data5[l]));
		end
	endgenerate
	
	genvar m;
	generate
		for (m=32;m<32;m=m+1) begin:BARREL11
			mux2_1 BARREL5 (.din_0(data4[m]),.din_1(data4[m-32]),.sel(shift[5]),.mux_out(data5[m]));
		end
	endgenerate
	
	assign outData = data5;


endmodule

//Testing

/*
module testBench;

	wire [31:0] outData,inData,shift;
	
	barrelShifter my_barrelShifter(outData,inData,shift);
	Tester my_Tester (outData,inData,shift);
	
	initial begin
		$dumpfile("barrelShifter.vcd");
		$dumpvars (1,my_barrelShifter);
	end

endmodule

module Tester (outData,inData,shift);
	input wire [31:0]outData;
	output reg [31:0]inData,shift;
	
	parameter stimDelay = 1;
	
	initial
	begin
		//$display ("\t clk \t address \t data \t RW \t OE");
		$monitor ("\t Indata:%b \t\t shift:%b \t\toutData:%b",inData,shift,outData);
	end

	initial
	begin
		#stimDelay;inData=1'b0;shift=1'b0;
		#stimDelay;inData=1'b1;shift=2'b00;
		#stimDelay;inData=1'b1;shift=2'b01;
		#stimDelay;inData=1'b1;shift=2'b10;
		#stimDelay;inData=1'b1;shift=2'b11;
		#stimDelay;inData=1'b1;shift=3'b100;
		#stimDelay;
		#stimDelay;
	end
	
endmodule
*/