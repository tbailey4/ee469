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
	wire SRAM_CS, SRAM_write,OE;
	
	//mux that controls Bus B of register data. 
	//if 0 use register data for Bus B, if 1 use constant(shamt) for Bus B
	wire Bselect, Dselect;
	wire [31:0] constant;
	
	//clk to control when to read and when to write
	wire clk;
	
	//for pc counter
	wire [6:0] branch;
	
	wire [10:0] ALUImm;
	
	control_signals mycontrol (SRAM_CS, SRAM_write, OE, read1_addr, read2_addr, write_addr, write_en,alu_function, ALUImm, branch, Bselect, constant, Dselect, opcode,Rm,Rn,Rd,Rt,shamt,DT_address,op,BR_Address,COND_BR_address,clk, FLAGS);
	instruction_decoder mydecoder (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address, ALUImm);
	
	control_signals_TESTER controlTester(instruction, clk);
	
	initial begin
		$dumpfile ("control_siganls.vcd");
		$dumpvars (4,controlTester);
	end

endmodule

module control_signals_TESTER (instruction, clk);

	output reg [31:0] instruction;
	
	
	output reg clk;
	
	
	integer i=0;
	parameter stimDelay=1;
	
	//NEED TEST CODE!!!!
	initial begin
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b10001011000000010001000011001010;
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b10010001000000000001110000001001;i=i+1;//addi
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b11111000000000000000001001101001;i=i+1;//stur
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b11111000010000000000001001101001;i=i+1;//ldur
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b11001011000010100000000100101011;i=i+1;//sub
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b11101011000011000000000101100000;i=i+1;//subs
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b01010100000000000000001010000000;i=i+1;//B.GT
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b11010011011000000001010100101001;i=i+1;//LSL
		#stimDelay; clk=0;
		#stimDelay; clk=1;instruction=32'b00010100000000000000000000011010;i=i+1;//b
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
		#stimDelay; clk=1;
		#stimDelay; clk=0;
	end

endmodule