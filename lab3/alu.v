module alu (outBus,Zero,Overflow,Carry,Negative,BusA,BusB,Control);

	output [31:0] outBus;
	output Zero,Overflow,Carry,Negative;
	input [31:0] BusA,BusB;
	input [2:0] Control;
	
	//And
	assign outBus= (Control==3'b011)? BusA&BusB:32'bZ;
	//Or
	assign outBus= (Control==3'b100)? BusA|BusB:32'bZ;
	//Xor
	assign outBus= (Control==3'b101)? BusA^BusB:32'bZ;
	//Left Shift
	assign outBus= (Control==3'b110)? BusA<<4:32'bZ;

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
	
	initial
		begin
			//$display ("\t clk \t address \t data \t RW \t OE");
			$monitor ("\t BusA:%b \t\t BusB:%b \t\t OutBus:%b \t\t Control:%b ",BusA,BusB,outBus,Control);
		end
	
	initial
		begin
			#stimDelay; BusA=1'b0;BusB=1'b0;Control=3'b011;
			#stimDelay;
			#stimDelay;
			#stimDelay; BusA=4'b0110; BusB=4'b0100;
			#stimDelay;
			#stimDelay;BusA=4'b0110;BusB=4'b1001;Control= 3'b100;
			#stimDelay;
			#stimDelay;BusA=4'b1111; Control = 3'b101;
			#stimDelay;
			#stimDelay;Control = 3'b110;
			#stimDelay;
			#stimDelay;
			#stimDelay;Control = 3'b000;
			#stimDelay;
			#stimDelay;
			#stimDelay;
			#stimDelay;
		end
	
endmodule
*/