`include "control_top.v"

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
		for (i=0;i<40;i=i+1) begin
			#stimDelay; clk=1'b1;
			#stimDelay; clk=1'b0;
		end
	end
	
endmodule