module instruction_memory ( instruction,addr, clk,write_enable);
	input [6:0] addr;
	input clk, write_enable;
	//input [31:0] write_data;
	output [31:0] instruction;
	
	reg [31:0] internalData [127:0];
	reg [31:0] outData;
	
	integer i;
	
	initial begin
		internalData[0]=1'b0;
		internalData[1]=1'b0;
		internalData[2]=32'b10010001000000000001110000001001;     // [0] ADDI    X9, XZR, #7              I  Rd = X9, Rn = XZR, ALUImm = 7
		internalData[3]=32'b11111000000000000000001001101001;   // [1] STUR    X9,[X19.#0]              D  DTAdr = 0, Rn = X19, Rt = X9, op^2 = 0
		internalData[4]=32'b10010001000000000001010000001010;     // [2] ADDI    X10, XZR, #5             I  Rd = X10, Rn = XZR, ALUImm = 5
		internalData[5]=32'b11111000000000000001001001101010;    // [3] STUR    X10.[X19.#1]             D  DTAdr = 1, Rn = X19, Rt = X10, op^2 = 0
		internalData[6]=32'b10010001000000000000100000001011;     // [4] ADDI    X11, XZR, #2             I  Rd = X11, Rn = XZR, ALUImm = 2
		internalData[7]=32'b11111000000000000010001001101011;    // [5] STUR    X11.[X19.#2]             D  DTAdr = 2, Rn = X19, Rt = X11, op^2 = 0
		internalData[8]=32'b10010001000000000001000000001100;     // [6] ADDI    X12, XZR, #4             I  Rd = X12, Rn = XZR, ALUImm = 4
		internalData[9]=32'b11111000000000000011001001101100;    // [7] STUR    X12.[X19.#3]             D  DTAdr = 3, Rn = X19, Rt = X12, op^2 = 0
		internalData[10]=32'b11111000010000000000001001101001;    // [8] LDUR    X9,  [X19.#0]            D  DTAdr = 0, Rn = X19, Rt = X9, op^2 = 0
		internalData[11]=32'b11111000010000000001001001101010;    // [9] LDUR    X10, [X19.#1]            D  DTAdr = 1, Rn = X19, Rt = X10, op^2 = 0
		internalData[12]=32'b11001011000010100000000100101011;    // [10] SUB     X11, X9, X10            R  Rm = X10, shamt = 0, Rn = X9, Rd = X11
		internalData[13]=32'b10010001000000000000110000001100;     // [11] ADDI    X12, XZR, #3            I  Rd = X12, Rn = XZR, ALUImm = 3
		internalData[14]=32'b11101011000011000000000101100000;    // [12] SUBS    XZR, X11, X12           R  Rm = X12, shamt = 0, Rn = X11, Rd = XZR, FLAG = R[Rn]-R[Rm]
		internalData[15]=32'b01010100000000000000000011100000;      // [13] B.GT    L1                      CB if(FLAG==(Z=0 & N=V) ) PC=PC+CondBranchAddress=PC+(20-13) 
		internalData[16]=32'b11111000010000000010001001101001;    // [14] LDUR    X9, [X19.#2]            D  DTAdr = 2, Rn = X19, Rt = X9, op^2 = 0
		internalData[17]=32'b11010011011000000001010100101001;    // [15] LSL     X9, X9, #5              R  Rm = 0, shamt = 5, Rn = X9 = Rd
		internalData[18]=32'b11111000000000000010001001101001;    // [16] STUR    X9, [X19.#2]            D  DTAdr = 2, Rn = X19, Rt = X9, op^2 = 0
		internalData[19]=32'b10010001000000000001110000001100;     // [17] ADDI    X12, XZR, #7            I  Rd = X12, Rn = XZR, ALUImm = 7
		internalData[20]=32'b11111000000000000011001001101100;    // [18] STUR    X12,[X19.#3]            D  DTAdr = 3, Rn = X19, Rt = X12, op^2 = 0
		internalData[21]=32'b00010100000000000000000000011010;       // [19] B       END
		internalData[22]=32'b10010001000000000001100000001100;     // [20] ADDI    X12, XZR, #6            I  Rd = X12, Rn = XZR, ALUImm = 6
		internalData[23]=32'b11111000000000000010001001101100;    // [21] STUR    X12,[X19.#2]            D  DTAdr = 2, Rn = X19, Rt = X12, op^2 = 0
		internalData[24]=32'b11111000010000000011001001101001;    // [22] LDUR    X9, [X19.#3]            D  DTAdr = 3, Rn = X19, Rt = X9, op^2 = 0
		internalData[25]=32'b11010011011000000000100100101001;    // [23] LSL     X9, X9, #2              R  Rm = 0, shamt = 2, Rn = X9 = Rd
		internalData[26]=32'b11111000000000000011001001101001;    // [24] STUR    X9,[X19.#3]             D  DTAdr = 3, Rn = X19, Rt = X9, op^2 = 0
		for (i=26;i<128; i=i+1) begin
			internalData[i]=i;
		end
	end
	
	//write data at neg edge
	//should make it more stable for writing
	/*always @(negedge clk) begin
		if (write_enable) begin
			internalData[addr]=instruction;
		end
	end*/
	//read data at pos edge
	always @ (posedge clk) begin
		//if (!write_enable) begin
			outData = internalData[addr];
		//end
	end
	
	assign instruction=outData;

endmodule