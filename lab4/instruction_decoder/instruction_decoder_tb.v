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
	wire [10:0] ALUImm;
	
	instruction_decoder myDecoder (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address, ALUImm);
	instruction_decoder_Tester DecoderTester (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address, ALUImm);
	
	initial begin
		$dumpfile ("instruction_decoder.vcd");
		$dumpvars (0,DecoderTester);
	
	end
	
endmodule

module instruction_decoder_Tester (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address, ALUImm);
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
	input wire [10:0] ALUImm;
	
	parameter stimDelay =1;
	
	integer i=0;
	
	initial begin
		$monitor ("instruction:%h opcode:%h Rm:%b Rn:%b Rd:%b Rt:%b shamt:%b DT_address:%d op:%b BR_Address:%d COND_BR_address:%d",instruction,opcode,Rm,Rn,Rd,Rt,shamt,DT_address,op,BR_Address,COND_BR_address);
	end
	
	initial begin
		#stimDelay;instruction=32'b10001011000000010001000011001000;
		#stimDelay; instruction=32'b10010001000000000001110000001001;i=i+1;//addi
		#stimDelay; instruction=32'b11111000000000000000001001101001;i=i+1;//stur
		#stimDelay; instruction=32'b11111000010000000000001001101001;i=i+1;//ldur
		#stimDelay; instruction=32'b11001011000010100000000100101011;i=i+1;//sub
		#stimDelay; instruction=32'b11101011000011000000000101100000;i=i+1;//subs
		#stimDelay; instruction=32'b01010100000000000000001010000000;i=i+1;//B.GT
		#stimDelay; instruction=32'b11010011011000000001010100101001;i=i+1;//LSL
		#stimDelay; instruction=32'b00010100000000000000000000011010;i=i+1;//b
		#stimDelay;
		#stimDelay;
		$finish;
	end
endmodule