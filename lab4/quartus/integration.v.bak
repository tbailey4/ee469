`include "control_top.v"
`include "SRAM_top.v"
`include "register_file.v"
`include "alu.v"
`include "mux32_2.v"
`include "mux32.v"
`include "zero_register.v"
`include "register_32.v"
`include "DFlipFlop.v"
`include "demux2.v"
`include "mux2_1.v"
`include "mux16.v"
`include "mux4.v"
`include "SRAM.v"

module integration (clk, fastclk,rst , KEY);
	
	input clk, fastclk,rst, KEY;
	
	//wires for control_top
	wire [2:0] alu_function;
	wire [4:0] read1_addr, read2_addr, write_addr;
	wire write_en;
	wire SRAM_CS, SRAM_write;
	wire Bselect;
	wire [31:0] constant;
	wire Dselect;
	reg V,C,N,Z, controlSuspend;
	
	wire [31:0] read2_data,read1_data,outBus, BusC,data;
	wire Zero,Overflow,Carry, Negative;
	
	wire [31:0] BusBalu, register_data;
	
	assign data=(!writeToSRAM)? read2_data :32'bZ ;
	assign register_data=read1_data;
	
	
	control_top controls (alu_function, //alu controls
		read1_addr, read2_addr, write_addr, write_en, //reg file controls
		SRAM_CS, SRAM_write, writeToSRAM, 	//sram controls
		Bselect, constant, 		//b mux select and input
		Dselect,				 //d mux select
		clk, V,C,N,Z, rst,		 //inputs
		register_data,  		//for branch reg
		controlSuspend);  		//input used to control the next step of control_top for demo purposes
		
	SRAM_top mySram (.data(data), .addr(outBus[10:0]), .CS(SRAM_CS), .write(SRAM_write), .clk(fastclk));
	register_file myreg (.read2_data(read2_data), .read1_data(read1_data), .read2_addr(read2_addr), 
					.read1_addr(read1_addr), .write_addr(write_addr), .write_data(BusC), .write_en(write_en), .clk(fastclk), .rst(rst));
					
	alu myalu (.outBus(outBus),.Zero(Zero),.Overflow(Overflow),.Carry(Carry),.Negative(Negative),.BusA(read1_data),.BusB(BusBalu),.Control(alu_function));
	
	mux32_2 B(.datain1(read2_data),.datain2(constant),.select(Bselect),.muxOut(BusBalu));
	mux32_2 D(.datain1(outBus),.datain2(data),.select(Dselect),.muxOut(BusC));
	
	
	//stores previous flag values for checks
	always @(negedge clk) begin
		V=Overflow;
		C=Carry;
		N=Negative;
		Z=Zero;
	end
	
	always @ (posedge clk) begin
		//if KEY=1'b1, control_top doesn't progress (For demo purposes)
		//if KEY=1'b0, control_top executes next instruction
		controlSuspend=KEY;
	end
	
endmodule