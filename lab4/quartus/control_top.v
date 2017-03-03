//`include "control_signals.v"
//`include "instruction_decoder.v"
//`include "instruction_memory.v"

module control_top (alu_function, //alu controls
		read1_addr, read2_addr, write_addr, write_en, //reg file controls
		SRAM_CS, SRAM_write, writeToSRAM,	//sram controls
		Bselect, constant, 		//b mux select and input
		Dselect,				 //d mux select
		clk, V,C,N,Z, rst,		 //inputs
		register_data,  		//for branch reg
		controlSuspend);  		//input used to control the next step of control_top for demo purposes
	
	//alu flags
	wire [3:0] FLAGS;
	
	//alu controls
	output [2:0] alu_function;
	
	//reg file controls
	output [4:0] read1_addr, read2_addr, write_addr;
	output write_en;
	
	//sram controls
	output SRAM_CS, SRAM_write,writeToSRAM;
	
	//mux that controls Bus B of register data. 
	//if 0 use register data for Bus B, if 1 use constant(shamt) for Bus B
	output Bselect;
	output [31:0]constant;
	
	//mux that controls the data out bus
	//if 1 data memory = data out, if 0 alu = data out
	output Dselect;
	
	input clk,V,C,N,Z, rst, controlSuspend;
	input [31:0] register_data;
	
	//internal wires for decoder/control_signals
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
	
	//used to write to instruction_memory
	reg write_enable;
	
	assign FLAGS[3]=V;
	assign FLAGS[2]=C;
	assign FLAGS[1]=N;
	assign FLAGS[0]=Z;
	
	//vestigial for now
	wire [6:0] branch;
	
	wire [31:0] instruction;
	wire [6:0] addr;
	
	
	control_signals outputSignals (SRAM_CS, SRAM_write, writeToSRAM, read1_addr, read2_addr, write_addr, write_en,alu_function, ALUImm, branch, Bselect, constant, Dselect, opcode,Rm,Rn,Rd,Rt,shamt,DT_address,op,BR_Address,COND_BR_address,clk, FLAGS);
	instruction_decoder decoder (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address, ALUImm);
	instruction_memory instrutMemory ( instruction,addr, clk,write_enable);
	
	reg [6:0] pcounter,nextPcounter; //program counter used as address for instruction memory
	
	//always block controls next pcounter
	always @ (*) begin
		if (controlSuspend) begin
			nextPcounter <= pcounter;
			
		end
			//if/elseif blocks handle branching
		else begin
			//register branch
			if (opcode == 11'h6B0) begin
				nextPcounter<=register_data;
			end
			// branch
			else if (opcode == 6'b000101) begin
				nextPcounter<=pcounter+BR_Address;
			end
			//B.GT
			else if (opcode == 8'b01010100) begin
				//TODO input condition here!!!!!!!!!!!!!!!
				//N high is a failure
				if (N) begin
					nextPcounter<=pcounter+1'b1;
				end
				else begin
					nextPcounter<=COND_BR_address;
				end
			end
			else if (opcode == 6'b000101) begin
				nextPcounter<= pcounter+BR_Address;
			end
			//else block handles no branching
			else begin 
				nextPcounter <= pcounter+1'b1;
			end
		end
	end
	
	always @ (posedge clk or negedge rst) begin
		if (!rst) begin
			pcounter=1'b0;
		end
		
		else if (pcounter == 7'd127 || instruction == 1'b0) begin
			pcounter <= pcounter;
		end
		
		else begin
			pcounter<=nextPcounter;
		end
	
	end
	
	assign addr=pcounter;
endmodule