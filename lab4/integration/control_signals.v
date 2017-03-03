module control_signals (COND_BR_address, BR_Address, opcode, instruction, SRAM_CS, SRAM_write, OE, read1_addr, read2_addr, write_addr, write_en,alu_function, branch, Bselect, constant, Dselect, clk, FLAGS);
	input [31:0] instruction;
	//decoder inputs
	output [10:0] opcode;
	reg [10:0] outopcode;
	reg [4:0] Rm;
	reg [4:0] Rn;
	reg [4:0] Rd;
	reg [4:0] Rt;
	reg [4:0] shamt;
	reg [7:0] DT_address;
	reg [1:0] op;
	output reg [25:0] BR_Address;
	output reg [17:0] COND_BR_address;
	reg [10:0] ALUImm;
	
	//alu flags
	input [3:0] FLAGS;
	
	//alu controls
	output reg [2:0] alu_function;
	
	//reg file controls
	output reg [4:0] read1_addr, read2_addr, write_addr;
	output reg write_en;
	
	//sram controls
	output reg SRAM_CS, SRAM_write, OE;
	
	//mux that controls Bus B of register data. 
	//if 0 use register data for Bus B, if 1 use constant(shamt) for Bus B
	output reg Bselect;
	output reg [31:0] constant;
	
	//mux that controls the data out bus
	//if 1 data memory = data out, if 0 alu = data out
	output reg Dselect;
	
	//clk to control when to read and when to write
	input clk;
	
	//for pc counter
	output reg [6:0] branch;
	
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
	parameter LDUR = 11'h7C2;
	parameter ADDI = 10'b1001000100;
	parameter STUR = 11'h7C0;
	parameter SUBS = 11'h758;
	
	assign opcode =outopcode;
	
	//decoder
	always @ (*) begin
		//(ADD) add R
		if (instruction[31:21]==11'h458/*11'b10001011000*/) begin
			outopcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(AND) and R
		else if (instruction [31:21]==11'h450) begin
			outopcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(ANDI) andi R
		else if (instruction[31:21]>=11'h488 &&instruction[31:21]<=11'h489) begin
			outopcode= 10'b1001000100;
			Rn=instruction[9:5];
			ALUImm=instruction[21:10];
			Rd=instruction[4:0];
		end
		//(B) branch B
		else if (instruction[31:21]>=11'h0A0 &&instruction[31:21]<=11'h0BF) begin
			outopcode = 6'b000101;
			BR_Address= instruction[25:0];
		end
		//(B.GT) branch greater than CB (MAY BE WRONG CHECK!!!!)
		else if (instruction[31:21]>=11'h2A0 &&instruction[31:21]<=11'h2A7) begin
			outopcode = 8'b01010100;
			COND_BR_address = instruction[23:5];
			Rt = instruction[4:0];
		end
		//(BR) branch register R
		else if (instruction [31:21]==11'h6B0) begin
			outopcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(EOR) exclusive Or R
		else if (instruction [31:21]==11'h650) begin
			outopcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		// (LDUR) Load Register D
		else if (instruction [31:21]==11'h7C2) begin
			outopcode = instruction [31:21];
			DT_address=instruction[20:12];
			op=instruction[11:10];
			Rn=instruction[9:5];
			Rt=instruction[4:0];
		end
		//(LDURSW) Load Word D
		else if (instruction [31:21]==11'h5C4) begin
			outopcode = instruction [31:21];
			DT_address=instruction[20:12];
			op=instruction[11:10];
			Rn=instruction[9:5];
			Rt=instruction[4:0];
		end
		//(LSL) Shift Left Logic R
		else if (instruction [31:21]==11'h69B) begin
			outopcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(ORR) Inclusive OR R
		else if (instruction [31:21]==11'h550) begin
			outopcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		// (STUR) D
		else if (instruction [31:21]==11'h7C0) begin
			outopcode = instruction [31:21];
			DT_address=instruction[20:12];
			op=instruction[11:10];
			Rn=instruction[9:5];
			Rt=instruction[4:0];
		end
		//(STURW) Store Word D
		else if (instruction [31:21]==11'h5C0) begin
			outopcode = instruction [31:21];
			DT_address=instruction[20:12];
			op=instruction[11:10];
			Rn=instruction[9:5];
			Rt=instruction[4:0];
		end
		//(SUB) Subtraction R
		else if (instruction [31:21]==11'h658) begin
			outopcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//(SUBS) Subtraction and set flags R
		else if (instruction [31:21]==11'h758) begin
			outopcode = instruction [31:21];
			Rm = instruction [20:16];
			shamt = instruction [15:10];
			Rn= instruction [9:5];
			Rd = instruction [4:0];
		end
		//NOP
		//else outopcode = 1'b0;
	end
	
	always @ (*) begin
		case (opcode)
			//Set up so Nothing is being writen to
			//and alu is NOP
			NOP: begin
				OE=1'b0;
				write_en=1'b0;
				branch=1'b0;
				SRAM_CS=1'b0; 
				SRAM_write=1'b0;
				Dselect=1'b0;
			end
			//Addition
			ADD://load data onto alu
				if (clk) begin
					OE=1'b0;
					Bselect=1'b0;
					read1_addr=Rn;
					read2_addr=Rm;
					write_addr=Rd;
					write_en=1'b0;
					alu_function=3'b001;
					branch=1'b0;
					SRAM_CS=1'b0; 
					SRAM_write=1'b0;
					Dselect=1'b0;
				end 
				//write result to register
				else if (!clk) begin
					write_en=1'b1;
				end
			ADDI://load data onto alu
				if (clk) begin
					OE=1'b0;
					Bselect=1'b1;
					constant=ALUImm;
					read1_addr=Rn;
					read2_addr=Rm;
					write_addr=Rd;
					write_en=1'b0;
					alu_function=3'b001;
					branch=1'b0;
					SRAM_CS=1'b0; 
					SRAM_write=1'b0;
					Dselect=1'b0;
				end 
				//write result to register
				else if (!clk) begin
					write_en=1'b1;
				end
			AND://load data onto alu
				if (clk) begin
					OE=1'b0;
					Bselect=1'b0;
					read1_addr=Rn;
					read2_addr=Rm;
					write_addr=Rd;
					write_en=1'b0;
					alu_function=3'b011;
					branch=1'b0;
					SRAM_CS=1'b0; 
					SRAM_write=1'b0;
					Dselect=1'b0;
				end 
				//write result to register
				else if (!clk) begin
					write_en=1'b1;
				end
			B: begin
					//outputs new instruction address, must be added to pc in top module
					branch=BR_Address;
				end
			/*BGT: //TODO not sure how to write yet
				begin
				//	COND_BR_address=
				end*/
			BR:read1_addr = Rt;
			EOR://load data onto alu
				if (clk) begin
					OE=1'b0;
					Bselect=1'b0;
					read1_addr=Rn;
					read2_addr=Rm;
					write_addr=Rd;
					write_en=1'b0;
					alu_function=3'b101;
					branch=1'b0;
					SRAM_CS=1'b0; 
					SRAM_write=1'b0;
					Dselect=1'b0;
				end 
				//write result to register
				else if (!clk) begin
					write_en=1'b1;
				end
			LDUR: 
				if (clk) begin
					OE=1'b0;
					read1_addr=Rn;
					Bselect=1'b1;
					constant=DT_address;
					alu_function=3'b001;
					write_addr=Rt;
					write_en=1'b0;
					SRAM_CS=1'b1; 
					Dselect=1'b1;
				end
				else if (!clk) begin
					write_en=1'b1;
				end
			LDURSW: //TODO need to know how to operate the sram
				if (clk) begin
					OE=1'b0;
					read1_addr=Rn;
					Bselect=1'b1;
					constant=DT_address;
					alu_function=3'b001;
					write_addr=Rt;
					write_en=1'b0;
					SRAM_CS=1'b1; 
					Dselect=1'b1;
				end
				else if (!clk) begin
					write_en=1'b1;
				end
			LSL://load data onto alu
				if (clk) begin
					OE=1'b0;
					Bselect=1'b1;
					read1_addr=Rn;
					write_addr=Rd;
					constant=shamt;
					write_en=1'b0;
					alu_function=3'b110;
					branch=1'b0;
					SRAM_CS=1'b0; 
					SRAM_write=1'b0;
					Dselect=1'b0;
				end 
				//write result to register
				else if (!clk) begin
					write_en=1'b1;
				end
			OOR://load data onto alu
				if (clk) begin
					OE=1'b0;
					Bselect=1'b0;
					read1_addr=Rn;
					read2_addr=Rm;
					write_addr=Rd;
					write_en=1'b0;
					alu_function=3'b100;
					branch=1'b0;
					SRAM_CS=1'b0; 
					SRAM_write=1'b0;
					Dselect=1'b0;
				end 
				//write result to register
				else if (!clk) begin
					write_en=1'b1;
				end
			STUR:
				if (clk) begin
				OE=1'b1;
				//target data
				read2_addr=Rt;
				//address data stored in reg
				//add constant for sram address
				read1_addr=Rn;
				constant=DT_address;
				alu_function=3'b001;
				//route result to sram with b select
				Bselect=1'b1;
				SRAM_CS=1'b1; 
				SRAM_write=1'b0;
				Dselect=1'b0;
				
				SRAM_write=1'b0;
				
				end
				//write data
				else if (!clk) begin
					SRAM_write=1'b1;
				end
			STURW://prep data and address for write
			if (clk) begin
				OE=1'b1;
				//target data
				read2_addr=Rt;
				//address data stored in reg
				//add constant for sram address
				read1_addr=Rn;
				constant=DT_address;
				alu_function=3'b001;
				//route result to sram with b select
				Bselect=1'b1;
				SRAM_CS=1'b1; 
				SRAM_write=1'b0;
				Dselect=1'b0;
				
				SRAM_write=1'b0;
				
			end
				//write data
			else if (!clk) begin
				SRAM_write=1'b1;
			end
			SUB://load data onto alu
				if (clk) begin
					OE=1'b0;
					Bselect=1'b0;
					read1_addr=Rn;
					read2_addr=Rm;
					write_addr=Rd;
					write_en=1'b0;
					alu_function=3'b001;
					branch=1'b0;
					SRAM_CS=1'b0; 
					SRAM_write=1'b0;
					Dselect=1'b0;
				end 
				//write result to register
				else if (!clk) begin
					write_en=1'b1;
				end
			SUBS://load data onto alu
				if (clk) begin
					OE=1'b0;
					Bselect=1'b0;
					read1_addr=Rn;
					read2_addr=Rm;
					write_addr=Rd;
					write_en=1'b0;
					alu_function=3'b001;
					branch=1'b0;
					SRAM_CS=1'b0; 
					SRAM_write=1'b0;
					Dselect=1'b0;
				end 
				//write result to register
				else if (!clk) begin
					write_en=1'b1;
				end
		endcase
	end
	
	
endmodule