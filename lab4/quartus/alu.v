//`include "barrelShifter.v"
//`include "CLA_adder.v"
//`include "signExtender.v"

module alu (outBus,Zero,Overflow,Carry,Negative,BusA,BusB,Control);

	output [31:0] outBus;
	output Zero,Overflow,Carry,Negative;
	input [31:0] BusA,BusB;
	input [2:0] Control;
	wire [31:0] shift;//,and1,or1,xor1;
	wire [15:0] sum;
	wire outOverflow,outCarry;
	wire [31:0] outputSum,outputAnd,outputOr,outputXor,outputShift;
	//and1=BusA&BusB;
	//or1=;
	//xor1=;
	CLA_adder adder (.V(outOverflow), .C(outCarry), .sum(sum), .a(BusA[15:0]), .b(BusB[15:0]), .sub(Control==3'b010));
	signExtender extender (.outputNum(outputSum),.inputNum(sum));
	
	
	//assign outBus = (Control == 3'b000)? 32'bZ:32'bZ;
	//add
	assign outBus=(Control == 3'b001)? outputSum:32'bZ;
	//sub
	assign outBus=(Control == 3'b010)? outputSum:32'bZ;
	//And
	//signExtender extender1 (.outputNum(outputAnd),.inputNum(BusA[15:0]&BusB[15:0]));
	assign outBus= (Control==3'b011)? BusA&BusB:32'bZ;
	//Or
	assign outBus= (Control==3'b100)? BusA|BusB:32'bZ;
	//signExtender extender2 (.outputNum(outputOr),.inputNum(BusA[15:0]|BusB[15:0]));
	//Xor
	assign outBus= (Control==3'b101)? BusA^BusB:32'bZ;
	//signExtender extender3 (.outputNum(outputXor),.inputNum(BusA[15:0]^BusB[15:0]));
	//Left Shift
	//assign outBus= (Control==3'b110)? BusA<<4:32'bZ;
	barrelShifter my_barrelShifter (.outData(shift),.inData(BusA),.shift(BusB));
	//signExtender extender4 (.outputNum(outputShift),.inputNum(shift[15:0]));
	assign outBus= (Control==3'b110)?shift:32'bZ;
	
	assign Overflow=(Control==3'b001 || Control==3'b010) ? outOverflow:1'b0;
	assign Carry=(Control==3'b001 || Control==3'b010) ? outCarry:1'b0;
	assign Zero=(outBus==1'b0)? 1'b1:1'b0;
	assign Negative=(outBus[31]==1'b1)? 1'b1:1'b0;
endmodule

//TESTING
/*
module testBench;
	wire [31:0] outBus;
	wire Zero,Overflow,Carry,Negative;
	wire [31:0] BusA,BusB;
	wire [2:0] Control;
	
	alu my_alu(outBus,Zero,Overflow,Carry,Negative,BusA,BusB,Control);
	
	Tester aTester(outBus,Zero,Overflow,Carry,Negative,BusA,BusB,Control);
	
	initial begin
		$dumpfile("alu.vcd");
		$dumpvars (1,my_alu);
	end
	
endmodule

module Tester (outBus,Zero,Overflow,Carry,Negative,BusA,BusB,Control);

	input wire [31:0] outBus;
	input wire Zero,Overflow,Carry,Negative;
	output reg [31:0] BusA,BusB;
	output reg [2:0] Control;
	
	parameter stimDelay = 1;
	integer i;
	initial
		begin
			//$display ("\t clk \t address \t data \t RW \t OE");
			$monitor ("BusA:%b \t BusB:%b \t OutBus:%b \t Control:%b Zero:%b Overflow:%b Carry:%b Negative:%b ",BusA,BusB,outBus,Control,Zero,Overflow,Carry,Negative);
		end
	
	initial
		begin
			#stimDelay;
			for (i=0;i<33;i=i+1) begin
			#stimDelay; Control=3'b110; BusA=1'b1;BusB=i;
			end
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'hAAAAAAAA; Control=3'b011;
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'h55555555; Control=3'b011;
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'hAAAAAAAA; Control=3'b100;
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'h55555555; Control=3'b100;
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'hAAAAAAAA; Control=3'b101;
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'h55555555; Control=3'b101;
			#stimDelay;
			#stimDelay; 
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'hAAAAAAAA; Control=3'b001;
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'h55555555; Control=3'b001;
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'hAAAAAAAA; Control=3'b010;
			#stimDelay; BusA=32'hAAAAAAAA; BusB=32'h55555555; Control=3'b010;
			#stimDelay; BusA=32'h00000000; BusB=32'hAAAAAAAA; Control=3'b001;
			#stimDelay; BusA=32'h00000000; BusB=32'h55555555; Control=3'b001;
			#stimDelay; BusA=32'h00000000; BusB=32'hAAAAAAAA; Control=3'b010;
			#stimDelay; BusA=32'h00000000; BusB=32'h55555555; Control=3'b010;
			#stimDelay; BusA=32'hFFFFFFFF; BusB=32'hAAAAAAAA; Control=3'b001;
			#stimDelay; BusA=32'hFFFFFFFF; BusB=32'h55555555; Control=3'b001;
			#stimDelay; BusA=32'hFFFFFFFF; BusB=32'hAAAAAAAA; Control=3'b010;
			#stimDelay; BusA=32'hFFFFFFFF; BusB=32'h55555555; Control=3'b010;
			#stimDelay; BusA=32'hFFFFFFFF; BusB=32'hFFFFFFFF; Control=3'b001;
			#stimDelay; BusA=32'hFFFFFFFF; BusB=32'hFFFFFFFF; Control=3'b010;
			#stimDelay;
			#stimDelay;
			

		end
	
endmodule
*/