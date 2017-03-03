`include "control_top.v"
//`include "SRAM.v"
`include "register_file.v"
`include "alu.v"
`include "mux32_2.v"
`include "mux32.v"
`include "zero_register.v"
`include "register_32.v"
`include "DFlipFlop.v"
`include "demux2.v"
`include "mux2_1.v"
`include "mux16.v"
`include "mux4.v"
`include "SRAM.v"
`include "mux2.v"
`include "CLA_adder.v"
`include "signExtender.v"
`include "barrelShifter.v"
`include "group_block.v"
`include "control_signals.v"
`include "integration.v"
//`include "control_signals.v"
//`include "instruction_decoder.v"
//`include "instruction_memory.v"

module integration_tb ();

	wire clk, fastclk, rst, KEY;

	integration myint (clk, fastclk,rst , KEY);

	integrationTester myTester (clk, fastclk,rst , KEY);
	initial begin
		$dumpfile ("integration.vcd");
		$dumpvars (0,myTester);
		$dumpvars (0,myint);
	end
endmodule

module integrationTester (clk, fastclk,rst , KEY);
	output reg clk, fastclk, rst, KEY;
	
	parameter stimDelay=1;
	
	integer i;
	
	initial begin
		#stimDelay; KEY=1'b1;
		#stimDelay; clk=1'b1;
		#stimDelay; clk=1'b0;
		#stimDelay; clk=1'b1;
		#stimDelay; clk=1'b0;
		#stimDelay; fastclk=1'b1;clk=1'b1; rst=1'b0;
		#stimDelay; fastclk=1'b0;
		#stimDelay; fastclk=1'b1;
		#stimDelay; fastclk=1'b0;
		#stimDelay; fastclk=1'b1;
		#stimDelay; fastclk=1'b0;
		#stimDelay; fastclk=1'b1;
		#stimDelay; fastclk=1'b0;
		#stimDelay; fastclk=1'b1;clk=1'b0;rst=1'b1;
		#stimDelay; fastclk=1'b0;
		#stimDelay; fastclk=1'b1;
		#stimDelay; fastclk=1'b0;
		#stimDelay; fastclk=1'b1;
		#stimDelay; fastclk=1'b0;
		#stimDelay; fastclk=1'b1;
		#stimDelay; fastclk=1'b0;
		for (i=0;i<100;i=i+1) begin
			#stimDelay; fastclk=1'b1;clk=1'b1; KEY=1'b0;
			#stimDelay; fastclk=1'b0;
			#stimDelay; fastclk=1'b1;
			#stimDelay; fastclk=1'b0;
			#stimDelay; fastclk=1'b1;
			#stimDelay; fastclk=1'b0;
			#stimDelay; fastclk=1'b1;
			#stimDelay; fastclk=1'b0;
			#stimDelay; fastclk=1'b1;clk=1'b0;
			#stimDelay; fastclk=1'b0;
			#stimDelay; fastclk=1'b1;
			#stimDelay; fastclk=1'b0;
			#stimDelay; fastclk=1'b1;
			#stimDelay; fastclk=1'b0;
			#stimDelay; fastclk=1'b1;
			#stimDelay; fastclk=1'b0;
		end
	end
endmodule