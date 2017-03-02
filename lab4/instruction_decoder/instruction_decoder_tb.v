`include "instruction_decoder.v"

module instruction_decoder_tb ();
	
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
	
	instruction_decoder myDecoder (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address);
	instruction_decoder_Tester DecoderTester (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address);
	
	initial begin
		$dumpfile ("instruction_decoder.vcd");
		$dumpvars (0,DecoderTester);
	
	end
	
endmodule

module instruction_decoder_Tester (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address);
	output reg [31:0] instruction;
	input wire [10:0] opcode;
	input wire [4:0] Rm;
	input wire [4:0] Rn;
	input wire [4:0] Rd;
	input wire [4:0] Rt;
	input wire [4:0] shamt;
	input wire [7:0] DT_address;
	input wire [1:0] op;
	input wire [25:0] BR_Address;
	input wire [17:0] COND_BR_address;
	
	parameter stimDelay =1;
	
	initial begin
		$monitor ("instruction:%h opcode:%h Rm:%b Rn:%b Rd:%b Rt:%b shamt:%b DT_address:%d op:%b BR_Address:%d COND_BR_address:%d",instruction,opcode,Rm,Rn,Rd,Rt,shamt,DT_address,op,BR_Address,COND_BR_address);
	end
	
	initial begin
		#stimDelay;instruction=32'b10001011000000010001000011001000;
		#stimDelay; instruction=32'b10001011000000010001000011001000;
		#stimDelay; instruction=32'b10001011000000010001000011001010;
		#stimDelay;
		#stimDelay;
		$finish;
	end
endmodule