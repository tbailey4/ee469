//`include "MAR.v"
//`include "MDR.v"
//`include "SRAMmemory.v"

module SRAM (data, address,OE,CS,RW, clk/*,data1out,data2out*/);
	
	//output  [15:0] data1out,data2out;
	//wire [15:0] data1,data2;
	//assign data1out=data1;
	//assign data2out=data2;
	
	
	inout [31:0] data;
	input [10:0] address;
	input OE,CS,RW,clk;
	
	wire [10:0] MemAddress1,MemAddress2;
	wire [15:0] MemData1,MemData2;//,MemData12,MemData22;
	//logic [15:0] MemDataTransfer1,MemDataTransfer2;
	
	MAR myMAR (address,MemAddress1,MemAddress2,clk);
	MDR myMDR (data,MemData1,MemData2,OE,clk);
	SRAMmemory mySRAMmemory (MemData1, MemData2, clk, MemAddress1, MemAddress2,CS, OE, RW/*,data1,data2*/);
	

	
	//assign data1=MemData1;
	//assign data2=MemData2;
	
	/*
	always @ (*)
		begin
			if (OE)
			begin
				MemDataTransfer1=MemData12;
				MemDataTransfer2=MemData22;
			end
			else 
			begin
				MemDataTransfer1=MemData1;
				MemDataTransfer2=MemData2;
			end
		end
	
	assign MemData1=(OE)?MemDataTransfer1:16'bz;
	assign MemData2=(OE)?MemDataTransfer2:16'bz;
	*/
	
endmodule