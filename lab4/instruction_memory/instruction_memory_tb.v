`include "instruction_memory.v"

module instruction_memory_tb();

	wire [6:0] addr;
	wire clk, write_enable;
	//input [31:0] write_data;
	wire [31:0] instruction;

	instruction_memory_Tester inMemTester (instruction,addr, clk,write_enable);
	instruction_memory memory (instruction,addr, clk,write_enable);
	
	initial begin
		$dumpfile ("instruction_memory.vcd");
		$dumpvars (1,memory);
	
	end

endmodule

module instruction_memory_Tester (instruction,addr, clk,write_enable);

	output reg [6:0] addr;
	output reg clk, write_enable;
	//input [31:0] write_data;
	inout wire [31:0] instruction;
	
	reg [31:0] data2;
	assign instruction= (write_enable) ? data2 : 32'bz;
	
	parameter stimDelay=1;
	
	initial begin
		$monitor ("addr:%d data:%h WE:%b clk:%b",addr, instruction,write_enable,clk);
	end
	
	
	integer i;
	initial begin
		#stimDelay; clk=1'b1;
		#stimDelay; clk=1'b0;
		/*for (i=0;i<128;i=i+1) begin
			
			
			
			#stimDelay; clk=1'b1;addr=i;data2=128-i;write_enable=1'b1;
			#stimDelay; clk=1'b0;
		end*/
		#stimDelay; clk=1'b1;
		#stimDelay; clk=1'b0;
		for (i=0;i<128;i=i+1) begin
			
			//write_data=128-i;
			
			#stimDelay; clk=1'b1;addr=i;write_enable=1'b0;
			#stimDelay; clk=1'b0;
		end
	end
endmodule