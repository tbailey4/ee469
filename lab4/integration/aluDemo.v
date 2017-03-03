//`include "alu.v"

module aluDemo (HEX0,HEX1,HEX2,HEX3,LEDR,SW,KEY,clk);
	output [6:0] HEX0,HEX1,HEX2,HEX3;
	input [9:0] SW;
	input [3:0] KEY;
	input clk;
	output [9:0] LEDR;
	
	reg [3:0] tHex0,tHex1,tHex2,tHex3;
	wire [6:0] oHex0,oHex1,oHex2,oHex3;
	reg [2:0] Control;
	reg [31:0]BusA,BusB,TempBusA,TempBusB,TempOutBus;
	wire Overflow,Carry,Negative,Zero;
	wire [31:0] outBus;
	reg outZero,outOverflow,outCarry,outNegative;
	integer i;
	reg start;
	
	
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
		i=0;
		start=1'b0;
	end
	/*
	always @ (posedge KEY[3]) begin
		if (KEY[3]) begin
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
	end
	*/
	always @ (negedge clk) begin
		if (KEY[1]) begin
			//TempOutBus=outBus;
			outNegative=Negative;
			outZero=Zero;
			outOverflow=Overflow;
			outCarry=Carry;
			TempOutBus=outBus;
			if (SW[9]) begin
		
			tHex3=TempOutBus[15:12];
			tHex2=TempOutBus[11:8];
			tHex1=TempOutBus[7:4];
			tHex0=TempOutBus[3:0];
		end
		else if (SW[8]) begin
			tHex3=TempBusB[15:12];
			tHex2=TempBusB[11:8];
			tHex1=TempBusB[7:4];
			tHex0=TempBusB[3:0];
		end
		else begin
			tHex3=TempBusA[15:12];
			tHex2=TempBusA[11:8];
			tHex1=TempBusA[7:4];
			tHex0=TempBusA[3:0];
		end
		end
	end
	
	always @ (posedge clk or posedge KEY[3]) begin
		if (KEY[3]) begin
			//tHex0=1'b0;
			//tHex1=1'b0;
			//tHex2=1'b0;
			//tHex3=1'b0;
			Control=1'b0;
			BusA=1'b0;
			BusB=1'b0;
			TempBusA=1'b0;
			TempBusB=1'b0;
			//TempOutBus=1'b0;
		end else begin
		

		//Modify Temp Data
		if (SW[3]&&(SW[9:8]==1'b0)) TempBusA[15:12]=TempBusA[15:12]+1'b1;
		if (SW[2]&&(SW[9:8]==1'b0)) TempBusA[11:8]=TempBusA[11:8]+1'b1;
		if (SW[1]&&(SW[9:8]==1'b0)) TempBusA[7:4]=TempBusA[7:4]+1'b1;
		if (SW[0]&&(SW[9:8]==1'b0)) TempBusA[3:0]=TempBusA[3:0]+1'b1;
		if (SW[3]&&(SW[9:8]==1'b1)) TempBusB[15:12]=TempBusB[15:12]+1'b1;
		if (SW[2]&&(SW[9:8]==1'b1)) TempBusB[11:8]=TempBusB[11:8]+1'b1;
		if (SW[1]&&(SW[9:8]==1'b1)) TempBusB[7:4]=TempBusB[7:4]+1'b1;
		if (SW[0]&&(SW[9:8]==1'b1)) TempBusB[3:0]=TempBusB[3:0]+1'b1;
		
		//Load the input data into the alu
		if (KEY[0]&&(SW[9:8]==1'b0)) BusA=TempBusA;
		else if (KEY[0]&&(SW[9:8]==1'b1)) BusB=TempBusB;
		
		//Control Input
		if (KEY[1]) begin
			start=1'b1;
			//PrevControl=Control;
			
		end	
		//else Control=1'b0;
		
		if (start) begin
			i=i+1;
			Control=i;
		end
		
		//Display
		/*if (SW[9]) begin
		
			tHex3=TempOutBus[15:12];
			tHex2=TempOutBus[11:8];
			tHex1=TempOutBus[7:4];
			tHex0=TempOutBus[3:0];
		end
		else if (SW[8]) begin
			tHex3=TempBusB[15:12];
			tHex2=TempBusB[11:8];
			tHex1=TempBusB[7:4];
			tHex0=TempBusB[3:0];
		end
		else begin
			tHex3=TempBusA[15:12];
			tHex2=TempBusA[11:8];
			tHex1=TempBusA[7:4];
			tHex0=TempBusA[3:0];
		end*/
		
		end

	end
	
	HexDecode hex0 (.outHex(oHex0),.code(tHex0));
	HexDecode hex1 (.outHex(oHex1),.code(tHex1));
	HexDecode hex2 (.outHex(oHex2),.code(tHex2));
	HexDecode hex3 (.outHex(oHex3),.code(tHex3));
	
	
	
	assign LEDR[9]=outCarry;
	assign LEDR[8]=outNegative;
	assign LEDR[7]=outOverflow;
	assign LEDR[6]=outZero;
	assign HEX0=oHex0;
	assign HEX1=oHex1;
	assign HEX2=oHex2;
	assign HEX3=oHex3;
	
endmodule


module HexDecode (outHex,code);
	input [3:0] code;
	reg [6:0] tempHex;
	output [6:0] outHex;
	
	always @ (*) begin
	case (code)
		4'b0000: 	tempHex = 7'b1000000; // 0 
		4'b0001: 	tempHex = 7'b1111001; // 1 
		4'b0010: 	tempHex = 7'b0100100; // 2 
		4'b0011: 	tempHex = 7'b0110000; // 3 
		4'b0100: 	tempHex = 7'b0011001; // 4 
		4'b0101: 	tempHex = 7'b0010010; // 5 
		4'b0110: 	tempHex = 7'b0000010; // 6 
		4'b0111: 	tempHex = 7'b1111000; // 7 
		4'b1000: 	tempHex = 7'b0000000; // 8 
		4'b1001: 	tempHex = 7'b0010000; // 9 
		4'b1010:		tempHex = 7'b0001000; // A
		4'b1011:		tempHex = 7'b0000011; // b	
		4'b1100:		tempHex = 7'b1000110; // C
		4'b1101:		tempHex = 7'b0100001; // d
		4'b1110:		tempHex = 7'b0000110; // E
		4'b1111:		tempHex = 7'b0001110; // F
		default tempHex = 7'bx; 		// default state
	endcase
	end
	
	assign outHex=tempHex;
endmodule

//TESTING

module testBench;

	wire [6:0] HEX0,HEX1,HEX2,HEX3;
	wire [9:0] SW;
	wire [3:0] KEY;
	wire [9:0] LEDR;
	wire clk;
	
	aluDemo my_aluDemo (HEX0,HEX1,HEX2,HEX3,LEDR,SW,KEY,clk);
	Tester aTester (HEX0,HEX1,HEX2,HEX3,LEDR,SW,KEY,clk);

	initial begin
		$dumpfile ("aluDemo.vcd");
		$dumpvars (1,my_aluDemo);
	end
	
endmodule

module Tester (HEX0,HEX1,HEX2,HEX3,LEDR,SW,KEY,clk);

	input wire [6:0] HEX0,HEX1,HEX2,HEX3;
	input wire [9:0] LEDR;
	output reg [9:0] SW;
	output reg [3:0] KEY;
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
			for (i=0;i<28;i=i+1) begin
				#stimDelay; clk=1'b1; SW[0]=1'b1;SW[9:8]=1'b0;
				#stimDelay; clk=1'b0;
			
			end
			#stimDelay; clk=1'b1;SW[0]=1'b0;SW[9:8]=1'b0;
			#stimDelay; clk=1'b0;
			for (i=0;i<5;i=i+1) begin
				#stimDelay; clk=1'b1; SW[0]=1'b1;SW[9:8]=1'b1;
				#stimDelay; clk=1'b0;
			
			end
			
			#stimDelay; clk=1'b1;SW[0]=1'b0;SW[9:8]=1'b0;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; 
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[0]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; SW[9:8]=1'b0;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[0]=1'b0;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; SW[9:8]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[0]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[0]=1'b0;
			#stimDelay; clk=1'b0;
			
			
			#stimDelay; clk=1'b1; KEY[1]=1'b1; SW[6:4]=3'b011;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[1]=1'b0;
			#stimDelay; clk=1'b0;
			
			#stimDelay; clk=1'b1; KEY[1]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[1]=1'b0;
			#stimDelay; clk=1'b0;
			
			#stimDelay; clk=1'b1; KEY[1]=1'b1; SW[6:4]=3'b100;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[1]=1'b0;
			#stimDelay; clk=1'b0;
			
			#stimDelay; clk=1'b1; KEY[1]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[1]=1'b0;
			#stimDelay; clk=1'b0;
			
			#stimDelay; clk=1'b1; KEY[1]=1'b1; SW[6:4]=3'b101;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[1]=1'b0;
			#stimDelay; clk=1'b0;
			
			#stimDelay; clk=1'b1; KEY[1]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[1]=1'b0;
			#stimDelay; clk=1'b0;
			
			#stimDelay; clk=1'b1; KEY[1]=1'b1; SW[6:4]=3'b110;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[1]=1'b0;
			#stimDelay; clk=1'b0;
			
			#stimDelay; clk=1'b1; KEY[1]=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1; KEY[1]=1'b0;
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
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;

		end

endmodule
