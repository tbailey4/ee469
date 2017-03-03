`include "../control_signals/control_signals.v"
`include "../instruction_decoder/instruction_decoder.v"
`include "../instruction_memory/instruction_memory.v"

module control_top (alu_function, //alu controls
		read1_addr, read2_addr, write_addr, write_en, //reg file controls
		SRAM_CS, SRAM_write, writeToSRAM, OE,	//sram controls
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
	output SRAM_CS, SRAM_write,writeToSRAM, OE;
	
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
	wire [25:0] BR_Address;
	wire [17:0] COND_BR_address;
	/*wire [4:0] Rm;
	wire [4:0] Rn;
	wire [4:0] Rd;
	wire [4:0] Rt;
	wire [4:0] shamt;
	wire [7:0] DT_address;
	wire [1:0] op;
	
	
	wire [10:0] ALUImm;*/
	
	//used to write to instruction_memory
	reg write_enable;
	
	//assign FLAGS[3]=V;
	//assign FLAGS[2]=C;
	//assign FLAGS[1]=N;
	//assign FLAGS[0]=Z;
	
	//vestigial for now
	wire [6:0] branch;
	
	wire [31:0] instruction;
	wire [6:0] addr;
	
	reg [6:0] pcounter,nextPcounter; //program counter used as address for instruction memory
	
	initial begin
		write_enable = 1'b0;
	end
	
	
	control_signals outputSignals (COND_BR_address, BR_Address, opcode, instruction, SRAM_CS, SRAM_write, OE, read1_addr, read2_addr, write_addr, write_en,alu_function, branch, Bselect, constant, Dselect, clk, FLAGS);
	//instruction_decoder decoder (instruction, opcode, Rm, Rn, Rd, Rt, shamt, DT_address, op,BR_Address, COND_BR_address, ALUImm);
	//instruction_memory instrutMemory ( .instruction(instruction),.addr(pcounter), .clk(clk),.write_enable(write_enable));
	
	reg [31:0] internalData [127:0];
	
	integer i;
	initial begin
		//internalData[0]=1'b0;
		//internalData[1]=1'b0;
		internalData[0]=32'b10010001000000000001110000001001;     // [0] ADDI    X9, XZR, #7              I  Rd = X9, Rn = XZR, ALUImm = 7
		internalData[1]=32'b11111000000000000000001001101001;   // [1] STUR    X9,[X19.#0]              D  DTAdr = 0, Rn = X19, Rt = X9, op^2 = 0
		internalData[2]=32'b10010001000000000001010000001010;     // [2] ADDI    X10, XZR, #5             I  Rd = X10, Rn = XZR, ALUImm = 5
		internalData[3]=32'b11111000000000000001001001101010;    // [3] STUR    X10.[X19.#1]             D  DTAdr = 1, Rn = X19, Rt = X10, op^2 = 0
		internalData[4]=32'b10010001000000000000100000001011;     // [4] ADDI    X11, XZR, #2             I  Rd = X11, Rn = XZR, ALUImm = 2
		internalData[5]=32'b11111000000000000010001001101011;    // [5] STUR    X11.[X19.#2]             D  DTAdr = 2, Rn = X19, Rt = X11, op^2 = 0
		internalData[6]=32'b10010001000000000001000000001100;     // [6] ADDI    X12, XZR, #4             I  Rd = X12, Rn = XZR, ALUImm = 4
		internalData[7]=32'b11111000000000000011001001101100;    // [7] STUR    X12.[X19.#3]             D  DTAdr = 3, Rn = X19, Rt = X12, op^2 = 0
		internalData[8]=32'b11111000010000000000001001101001;    // [8] LDUR    X9,  [X19.#0]            D  DTAdr = 0, Rn = X19, Rt = X9, op^2 = 0
		internalData[9]=32'b11111000010000000001001001101010;    // [9] LDUR    X10, [X19.#1]            D  DTAdr = 1, Rn = X19, Rt = X10, op^2 = 0
		internalData[10]=32'b11001011000010100000000100101011;    // [10] SUB     X11, X9, X10            R  Rm = X10, shamt = 0, Rn = X9, Rd = X11
		internalData[11]=32'b10010001000000000000110000001100;     // [11] ADDI    X12, XZR, #3            I  Rd = X12, Rn = XZR, ALUImm = 3
		internalData[12]=32'b11101011000011000000000101100000;    // [12] SUBS    XZR, X11, X12           R  Rm = X12, shamt = 0, Rn = X11, Rd = XZR, FLAG = R[Rn]-R[Rm]
		internalData[13]=32'b01010100000000000000000011100000;      // [13] B.GT    L1                      CB if(FLAG==(Z=0 & N=V) ) PC=PC+CondBranchAddress=PC+(20-13) 
		internalData[14]=32'b11111000010000000010001001101001;    // [14] LDUR    X9, [X19.#2]            D  DTAdr = 2, Rn = X19, Rt = X9, op^2 = 0
		internalData[15]=32'b11010011011000000001010100101001;    // [15] LSL     X9, X9, #5              R  Rm = 0, shamt = 5, Rn = X9 = Rd
		internalData[16]=32'b11111000000000000010001001101001;    // [16] STUR    X9, [X19.#2]            D  DTAdr = 2, Rn = X19, Rt = X9, op^2 = 0
		internalData[17]=32'b10010001000000000001110000001100;     // [17] ADDI    X12, XZR, #7            I  Rd = X12, Rn = XZR, ALUImm = 7
		internalData[18]=32'b11111000000000000011001001101100;    // [18] STUR    X12,[X19.#3]            D  DTAdr = 3, Rn = X19, Rt = X12, op^2 = 0
		internalData[19]=32'b00010100000000000000000000011010;       // [19] B       END
		internalData[20]=32'b10010001000000000001100000001100;     // [20] ADDI    X12, XZR, #6            I  Rd = X12, Rn = XZR, ALUImm = 6
		internalData[21]=32'b11111000000000000010001001101100;    // [21] STUR    X12,[X19.#2]            D  DTAdr = 2, Rn = X19, Rt = X12, op^2 = 0
		internalData[22]=32'b11111000010000000011001001101001;    // [22] LDUR    X9, [X19.#3]            D  DTAdr = 3, Rn = X19, Rt = X9, op^2 = 0
		internalData[23]=32'b11010011011000000000100100101001;    // [23] LSL     X9, X9, #2              R  Rm = 0, shamt = 2, Rn = X9 = Rd
		internalData[24]=32'b11111000000000000011001001101001;    // [24] STUR    X9,[X19.#3]             D  DTAdr = 3, Rn = X19, Rt = X9, op^2 = 0
		for (i=25;i<128; i=i+1) begin
			internalData[i]=i;
		end
	end
	
	assign instruction= internalData[pcounter];
	
	initial begin
		pcounter=1'b0;
		nextPcounter=1'b0;
	end
	
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
					nextPcounter<=pcounter+COND_BR_address;
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
		
		else if (pcounter == 7'd127 ) begin
			pcounter <= pcounter;
		end
		
		else begin
			pcounter<=nextPcounter;
		end
	
	end
	
	
	//assign addr=pcounter;
endmodule

module control_top_tb ();
	
	wire [2:0] alu_function;
	
	//reg file controls
	wire [4:0] read1_addr, read2_addr, write_addr;
	wire write_en;
	
	//sram controls
	wire SRAM_CS, SRAM_write,writeToSRAM, OE;
	
	//mux that controls Bus B of register data. 
	//if 0 use register data for Bus B, if 1 use constant(shamt) for Bus B
	wire Bselect;
	wire [31:0]constant;
	
	//mux that controls the data out bus
	//if 1 data memory = data out, if 0 alu = data out
	wire Dselect;
	
	wire clk,V,C,N,Z, rst, controlSuspend;
	wire [31:0] register_data;

	control_top myControl (alu_function, //alu controls
		read1_addr, read2_addr, write_addr, write_en, //reg file controls
		SRAM_CS, SRAM_write, writeToSRAM, OE,	//sram controls
		Bselect, constant, 		//b mux select and input
		Dselect,				 //d mux select
		clk, V,C,N,Z, rst,		 //inputs
		register_data,  		//for branch reg
		controlSuspend);  		//input used to control the next step of control_top for demo purposes
		
	controlTester myTester (alu_function, //alu controls
		read1_addr, read2_addr, write_addr, write_en, //reg file controls
		SRAM_CS, SRAM_write, writeToSRAM, OE,	//sram controls
		Bselect, constant, 		//b mux select and input
		Dselect,				 //d mux select
		clk, V,C,N,Z, rst,		 //inputs
		register_data,  		//for branch reg
		controlSuspend);  		//input used to control the next step of control_top for demo purposes
		
	initial begin
		$dumpfile ("control_top.vcd");
		$dumpvars (0,myTester);
		$dumpvars (1,myControl);
	end
endmodule

module controlTester (alu_function, //alu controls
		read1_addr, read2_addr, write_addr, write_en, //reg file controls
		SRAM_CS, SRAM_write, writeToSRAM, OE,	//sram controls
		Bselect, constant, 		//b mux select and input
		Dselect,				 //d mux select
		clk, V,C,N,Z, rst,		 //inputs
		register_data,  		//for branch reg
		controlSuspend);
	input wire [2:0] alu_function;
	
	//reg file controls
	input wire [4:0] read1_addr, read2_addr, write_addr;
	input wire write_en;
	
	//sram controls
	input wire SRAM_CS, SRAM_write,writeToSRAM, OE;
	
	//mux that controls Bus B of register data. 
	//if 0 use register data for Bus B, if 1 use constant(shamt) for Bus B
	input wire Bselect;
	input wire [31:0]constant;
	
	//mux that controls the data out bus
	//if 1 data memory = data out, if 0 alu = data out
	input wire Dselect;
	
	output reg clk,V,C,N,Z, rst, controlSuspend;
	output reg [31:0] register_data;
	
	parameter stimDelay =1;
	integer i;
	initial begin
		#stimDelay; clk=1'b0;controlSuspend=1'b1;
		#stimDelay; clk=1'b0;
		#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
		for (i=0;i<40;i=i+1) begin
			#stimDelay; clk=1'b1;controlSuspend=1'b0;
			#stimDelay; clk=1'b0;
		end
	end
	
endmodule