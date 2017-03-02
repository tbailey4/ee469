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
	
	
endmodule