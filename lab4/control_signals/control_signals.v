module control_signals (alu_function, opcode,Rm,Rn,Rd,Rt,shamt,DT_address,op,BR_Address,COND_BR_address);
	input [10:0] opcode;
	input [4:0] Rm;
	input [4:0] Rn;
	input [4:0] Rd;
	input [4:0] Rt;
	input [4:0] shamt;
	input [7:0] DT_address;
	input [1:0] op;
	input [25:0] BR_Address;
	input [17:0] COND_BR_address;
	output [2:0] alu_function;
	
	//Instruction Op Codes
	parameter NOP = 1'b0;
	parameter ADD = 11'h458;
	parameter AND = 11'h450;
	parameter B = 6'b000101;
	parameter BGT = 8'b01010100;
	parameter BR = 11'h6B0;
	parameter EOR = 11'h650;
	parameter LDURSW = 11'h5C4;
	parameter LSL = 11'h69B;
	parameter OOR = 11'h550;
	parameter STURW= 11'h5C0;
	parameter SUB = 11'h658;
	
	always @ (*) begin
		case (opcode)
	end
	
endmodule