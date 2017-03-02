`include "SRAM.v"

module testBench;
	wire [31:0] data;
	wire CS, OE, RW, clk;
	wire [10:0] address;
	
	SRAM my_SRAM (data, address,OE,CS,RW, clk);
	
	Tester aTester (data, address,OE,CS,RW, clk);
	
	initial
		begin
			$dumpfile ("tester.vcd");
			$dumpvars (1,my_SRAM);
		end
endmodule

module Tester (data, address,OE,CS,RW, clk);
	inout wire [31:0] data;
	output reg CS, OE, RW, clk;
	output reg [10:0] address;
	
	reg [31:0] data2=1'b0;
	
	integer i;
	
	parameter stimDelay = 1;
	assign data= (OE) ? data2 : 32'bz;
	
	initial
		begin
			//$display ("\t clk \t address \t data \t RW \t OE");
			$monitor ("\t clk:%b \t address:%d \t\t data:%d \t RW:%b \t OE:%b",clk,address,data,RW,OE);
		end
	initial
		begin
		/*
			for(i=0; i<128;i++) begin
				
				#stimDelay clk=1'b1;address=i; RW=1'b1; OE=1'b0;
				#stimDelay clk=1'b0;
			end
		*/
			
			CS=1'b0; i=0;
			#stimDelay clk=1'b1;address=i; data2=127-i; RW=1'b0; OE=1'b1;
				#stimDelay clk=1'b0;
				#stimDelay clk=1'b1; RW=1'b1;
				#stimDelay clk=1'b0;
			for(i=0; i<128;i=i+1) begin
				
				#stimDelay clk=1'b1;address=i; data2=127-i; RW=1'b0; OE=1'b1;
				#stimDelay clk=1'b0;
				//#stimDelay clk=1'b1;address=i; data2=127-i; RW=1'b0; OE=1'b1;
				//#stimDelay clk=1'b0;
				#stimDelay clk=1'b1; RW=1'b1;
				#stimDelay clk=1'b0;
				#stimDelay clk=1'b1;
				#stimDelay clk=1'b0;
				//#stimDelay clk=1'b1;
				//#stimDelay clk=1'b0;
				//#stimDelay clk=1'b1;
				//#stimDelay clk=1'b0;
				//#stimDelay clk=1'b1;
				//#stimDelay clk=1'b0;
				//#stimDelay clk=1'b1;
				//#stimDelay clk=1'b0;
				//#stimDelay clk=1'b1;
				//#stimDelay clk=1'b0;
			end
			CS=1'b0; i=0;
			for(i=0; i<128;i=i+1) begin
				
				#stimDelay clk=1'b1;address=i; RW=1'b1; OE=1'b0;
				#stimDelay clk=1'b0;
				#stimDelay clk=1'b1;
				#stimDelay clk=1'b0;
			end
		end
endmodule