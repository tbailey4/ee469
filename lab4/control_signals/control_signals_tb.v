`include "control_signals.v"
`include "../instruction_decoder/instruction_decoder.v"

module control_signals_tb ();
	
	wire [31:0] instruction;
	wire [10:0] opcode;
	wire [4:0] Rm;
	wire [4:0] Rn;
	wire [4:0] Rd;
	wire [4:0] Rt;
	wire [4:0] shamt;
	wire [7:0] DT_address;
	wire [1:0] op;
	wire [25:0] BR_Address;
	wire [17:0] COND_BR_address;
	
	//alu flags
	wire [3:0] FLAGS;
	
	//alu controls
	wire [2:0] alu_function;
	
	//reg file controls
	wire [4:0] read1_addr, read2_addr, write_addr;
	wire write_en;
	
	//sram controls
	wire SRAM_CS, SRAM_write;
	
	//mux that controls Bus B of register data. 
	//if 0 use register data for Bus B, if 1 use constant(shamt) for Bus B
	wire Bselect;
	wire constant;
	
	//clk to control when to read and when to write
	wire clk;
	
	//for pc counter
	wire [5:0] branch;
	
	control_signals mycontrol (SRAM_CS, SRAM_write, read1_addr, read2_addr, write_addr, write_en,alu_function, branch, Bselect, constant, Dselect, opcode,Rm,Rn,Rd,Rt,shamt,DT_address,op,BR_Address,COND_BR_address,clk, FLAGS);
	instruction_decoder mydecoder (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address);
	
	control_signals_TESTER controlTester(SRAM_CS, SRAM_write, read1_addr, read2_addr, write_addr, write_en,alu_function, branch, instruction,FLAGS, clk);
	
	initial begin
		$dumpfile ("control_siganls.vcd");
		$dumpvars (0,controlTester);
	end

endmodule

module control_signals_TESTER (SRAM_CS, SRAM_write, read1_addr, read2_addr, write_addr, write_en,alu_function, branch, instruction,FLAGS, clk);

	output reg [31:0] instruction;
	
	
	//alu flags
	output reg [3:0] FLAGS;
	
	//alu controls
	input wire [2:0] alu_function;
	
	//reg file controls
	input wire [4:0] read1_addr, read2_addr, write_addr;
	input wire write_en;
	
	//sram controls
	input wire SRAM_CS, SRAM_write;
	
	//mux that controls Bus B of register data. 
	//if 0 use register data for Bus B, if 1 use constant(shamt) for Bus B
	input wire Bselect;
	input wire constant;
	
	//clk to control when to read and when to write
	output reg clk;
	
	//for pc counter
	input wire [5:0] branch;
	
	input wire Dselect;
	
	parameter stimDelay=1;
	
	//NEED TEST CODE!!!!
	initial begin
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b10001011000000010001000011001010;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
	end

endmodule