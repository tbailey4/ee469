`include "SRAM.v"
module SRAM_demo (LEDR,/*,addressOut,*/SW9,HEX6,clk);
	output [9:0] LEDR;
	//output [10:0] addressOut;
	output [6:0] HEX6;
	input clk,SW9;
	
	wire [31:0] data;
	reg [31:0] inputData;
	reg [10:0] address;
	reg OE,CS,RW;
	wire [15:0] data1out,data2out;
	SRAM mySRAM(data, address,OE,CS,RW, clk,data1out,data2out);
	reg [10:0] addressOut;
	integer i;
	reg[1:0] counter;
	reg[6:0] number;
	
	initial begin
		address=1'b0;
		OE=1'b1;
		CS=1'b0;
		RW=1'b1;
		number=7'b1111111;
		i=0;
		counter=1'b0;
		
	end
	
	always @ (posedge SW9 or negedge SW9) number=7'b1111111;
	
	always @ (posedge clk) begin
		if (SW9) begin
			case (counter)
				2'b00: begin
							counter<=2'b01;
							number=number+1'b1;
							inputData=7'b1111111-number;
							
							OE<=1'b1;
							RW<=1'b0;
							address<=number;
						end
				2'b01: begin 
					counter<=2'b10;
					RW=1'b1;
					i=i+1;
				end
				2'b10: begin 
					counter<=2'b11;
					
				end
				2'b11: begin 
					counter<=2'b00;
					
				end
				default: counter<=2'b00;
			endcase
		end else begin
			case (counter)
				2'b00: begin
							counter<=2'b01;
							number=number+1'b1;
							address<=number;
							OE=1'b0;
							RW=1'b1;
						end
				2'b01: begin
					counter<=2'b00;
					addressOut<=number;
					i=i+1;
				end
				2'b10: counter<=2'b00;
				2'b11: counter<=2'b00;
				default: counter<=2'b00;
			endcase
		end
	end

	
	assign HEX6=addressOut[6:0];
	//assign addressOut=address;
	assign data=(OE)?inputData:32'bz;
	assign LEDR=data[9:0];
endmodule




//testing
module testBench;
	wire SW9,clk;
	/*wire [10:0] addressOut;*/
	wire [9:0] LEDR;
	wire [6:0] HEX6;
	
	SRAM_demo my_SRAM_demo (LEDR,/*addressOut*/SW9, HEX6,clk);
	
	Tester aTester (LEDR,/*addressOut,*/ SW9,HEX6,clk);
	
	initial
		begin
			$dumpfile ("SRAM_demo.vcd");
			$dumpvars (1,my_SRAM_demo);
		end
endmodule

module Tester (LEDR,/*addressOut,*/SW9, HEX6, clk);
	input wire [9:0] LEDR;
	//input wire [10:0] addressOut;
	input wire [6:0] HEX6;
	output reg SW9,clk;
	
	integer i;
	
	parameter stimDelay = 1;
	
	initial
		begin
			//$display ("\t clk \t address \t data \t RW \t OE");
			$monitor ("\t clk:%b \t address:%d \t\t LEDR:%b \t\t SW9:%b",clk,HEX6,LEDR, SW9);
		end
	initial
		begin
		i=0;
		for(i=0; i<512;i=i+1) begin
			SW9=1'b1;
			#stimDelay clk=1'b1;
			#stimDelay clk=1'b0;
		end
		i=0;
		for(i=0; i<512;i=i+1) begin
			SW9=1'b0;
			#stimDelay clk=1'b1;
			#stimDelay clk=1'b0;
		end
		$finish;
	end
endmodule
