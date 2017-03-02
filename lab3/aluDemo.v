`include "alu.v"

module aluDemo (HEX0,HEX1,HEX2,HEX3,SW,KEY,clk);
	output [15:0] HEX0,HEX1,HEX2,HEX3;
	input [9:0] SW;
	input [1:0] KEY;
	input clk;
	
	reg [15:0] tHex0,tHex1,tHex2,tHex3;
	reg [2:0] Control,PrevControl;
	reg [31:0]BusA,BusB,TempBusA,TempBusB,TempOutBus;
	wire Overflow,Carry,Negative,Zero;
	wire [31:0] outBus;
	
	alu my_alu(outBus,Zero,Overflow,Carry,Negative,BusA,BusB,Control);
	
	initial begin
		tHex0=1'b0;
		tHex1=1'b0;
		tHex2=1'b0;
		tHex3=1'b0;
		Control=1'b0;
		BusA=1'b0;
		BusB=1'b0;
		TempBusA=1'b0;
		TempBusB=1'b0;
		TempOutBus=1'b0;
	end
	
	always @ (negedge clk) begin
		if (KEY[1]) begin
			TempOutBus=outBus;
		end
	end
	
	always @ (posedge clk) begin
		//Modify Temp Data
		if (SW[3]&&(SW[9:8]==1'b0)) TempBusA[31:16]=TempBusA[31:16]+1'b1;
		if (SW[2]&&(SW[9:8]==1'b0)) TempBusA[15:0]=TempBusA[15:0]+1'b1;
		if (SW[1]&&(SW[9:8]==1'b1)) TempBusB[31:16]=TempBusB[31:16]+1'b1;
		if (SW[0]&&(SW[9:8]==1'b1)) TempBusB[15:0]=TempBusB[15:0]+1'b1;
		
		//Load the input data into the alu
		if (KEY[0]&&(SW[9:8]==1'b0)) BusA=TempBusA;
		else if (KEY[0]&&(SW[9:8]==1'b1)) BusB=TempBusB;
		
		//Control Input
		if (KEY[1]) begin
			Control=SW[6:4];
			PrevControl=Control;
			
		end	
		else Control=1'b0;
		
		//Display
		if (SW[9]) begin
			tHex2=PrevControl;
			tHex3=SW[6:4];
			tHex1=TempOutBus[31:16];
			tHex0=TempOutBus[15:0];
		end
		else if (SW[8]) begin
			tHex3=TempBusB[31:16];
			tHex2=TempBusB[15:0];
			tHex1=BusB[31:16];
			tHex0=BusB[15:0];
		end
		else begin
			tHex3=TempBusA[31:16];
			tHex2=TempBusA[15:0];
			tHex1=BusA[31:16];
			tHex0=BusA[15:0];
		end

	end
	
	assign HEX0=tHex0;
	assign HEX1=tHex1;
	assign HEX2=tHex2;
	assign HEX3=tHex3;
	
endmodule


//TESTING
module testBench;

	wire [15:0] HEX0,HEX1,HEX2,HEX3;
	wire [9:0] SW;
	wire [1:0] KEY;
	wire clk;
	
	aluDemo my_aluDemo (HEX0,HEX1,HEX2,HEX3,SW,KEY,clk);
	Tester aTester (HEX0,HEX1,HEX2,HEX3,SW,KEY,clk);

	initial begin
		$dumpfile ("aluDemo.vcd");
		$dumpvars (1,my_aluDemo);
	end
	
endmodule

module Tester (HEX0,HEX1,HEX2,HEX3,SW,KEY,clk);

	input wire [15:0] HEX0,HEX1,HEX2,HEX3;
	output reg [9:0] SW;
	output reg [1:0] KEY;
	output reg clk;
	
	parameter stimDelay = 1;
	
	initial
		begin
			//$display ("\t clk \t address \t data \t RW \t OE");
			$monitor ("clk:%b\t HEX1:%b \t\t HEX0:%b \t\t HEX3:%b \t\t HEX2:%b \t KEY0:%b\t KEY1:%b",clk, HEX1,HEX0,HEX3,HEX2,KEY[0],KEY[1]);
		end
	
	integer i;
	
	initial
		begin
			#stimDelay; clk=1'b1; SW=1'b0; KEY=1'b0;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; SW[9:8]=1'b0; SW[3]=1'b1; 
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; SW[3]=1'b0; SW[6:4]=3'b101; KEY[0]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[0]=1'b0; KEY[1]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[1]=1'b0;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; SW[9]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;SW[6:4]=1'b0;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;

		end

endmodule