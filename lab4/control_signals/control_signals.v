module control_signals (SRAM_CS, SRAM_write, writeToSRAM, read1_addr, read2_addr, write_addr, write_en,alu_function, ALUImm, branch, Bselect, constant, Dselect, opcode,Rm,Rn,Rd,Rt,shamt,DT_address,op,BR_Address,COND_BR_address,clk, FLAGS);
	//decoder inputs
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
	input [10:0] ALUImm;
	
	//alu flags
	input [3:0] FLAGS;
	
	//alu controls
	output reg [2:0] alu_function;
	
	//reg file controls
	output reg [4:0] read1_addr, read2_addr, write_addr;
	output reg write_en;
	
	//sram controls
	output reg SRAM_CS, SRAM_write, writeToSRAM;
	
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
	
	//ALU functions
	
	
	always @ (*) begin
		case (opcode)
			//Set up so Nothing is being writen to
			//and alu is NOP
			NOP: begin
				writeToSRAM=1'b0;
				write_en=1'b0;
				branch=1'b0;
				SRAM_CS=1'b0; 
				SRAM_write=1'b0;
				Dselect=1'b0;
			end
			//Addition
			ADD://load data onto alu
				if (clk) begin
					writeToSRAM=1'b0;
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
					writeToSRAM=1'b0;
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
					writeToSRAM=1'b0;
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
			//BGT: //TODO not sure how to write yet
			BR:read1_addr = Rt;
			EOR://load data onto alu
				if (clk) begin
					writeToSRAM=1'b0;
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
					writeToSRAM=1'b0;
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
					writeToSRAM=1'b0;
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
					writeToSRAM=1'b0;
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
					writeToSRAM=1'b0;
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
				writeToSRAM=1'b1;
				
				end
				//write data
				else if (!clk) begin
					SRAM_write=1'b1;
				end
			STURW://prep data and address for write
			if (clk) begin
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
				writeToSRAM=1'b1;
				
			end
				//write data
			else if (!clk) begin
				SRAM_write=1'b1;
			end
			SUB://load data onto alu
				if (clk) begin
					writeToSRAM=1'b0;
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
					writeToSRAM=1'b0;
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