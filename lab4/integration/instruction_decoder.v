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
		//(ADD) add R
		if (instruction[31:21]==11'h458/*11'b10001011000*/) begin
			opcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(AND) and R
		else if (instruction [31:21]==11'h450) begin
			opcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(B) branch B
		else if (instruction[31:21]>=11'h0A0 &&instruction[31:21]<=11'h0BF) begin
			opcode = 6'b000101;
			BR_Address= instruction[25:0];
		end
		//(B.GT) branch greater than CB (MAY BE WRONG CHECK!!!!)
		else if (instruction[31:21]>=11'h2A0 &&instruction[31:21]<=11'h2A7) begin
			opcode = 8'b01010100;
			COND_BR_address = instruction[23:5];
			Rt = instruction[4:0];
		end
		//(BR) branch register R
		else if (instruction [31:21]==11'h6B0) begin
			opcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(EOR) exclusive Or R
		else if (instruction [31:21]==11'h650) begin
			opcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(LDURSW) Load Word D
		else if (instruction [31:21]==11'h5C4) begin
			opcode = instruction [31:21];
			DT_address=instruction[20:12];
			op=instruction[11:10];
			Rn=instruction[9:5];
			Rt=instruction[4:0];
		end
		//(LSL) Shift Left Logic R
		else if (instruction [31:21]==11'h69B) begin
			opcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(ORR) Inclusive OR R
		else if (instruction [31:21]==11'h550) begin
			opcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(STURW) Store Word D
		else if (instruction [31:21]==11'h5C0) begin
			opcode = instruction [31:21];
			DT_address=instruction[20:12];
			op=instruction[11:10];
			Rn=instruction[9:5];
			Rt=instruction[4:0];
		end
		//(SUB) Subtraction R
		else if (instruction [31:21]==11'h658) begin
			opcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//NOP
		else opcode = 1'b0;
	end
	

endmodule