module instruction_decoder (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address);

	input [31:0] instruction;
	output reg [10:0] opcode;
	output reg [4:0] Rm;
	output reg [4:0] Rn;
	output reg [4:0] Rd;
	output reg [4:0] Rt;
	output reg [4:0] shamt;
	output reg [7:0] DT_address;
	output reg [1:0] op;
	output reg [25:0] BR_Address;
	output reg [17:0] COND_BR_address;
	
	always @ (*) begin
		if (instruction[31:21]==11'h458) begin
			opcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
	
	end
	

endmodule