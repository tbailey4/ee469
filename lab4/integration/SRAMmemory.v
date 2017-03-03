//`include "memory.v"

module SRAMmemory (MemData1, MemData2, clk, MemAddress1, MemAddress2,CS, OE, RW);

    //bidirection data
	inout [15:0] MemData1;
	inout [15:0] MemData2;
	//Chip Select(CS), Output Enabled (OE), Read/Write (RW), clock (clk)
	input CS, OE, RW, clk;
	//Stores the address
	input [10:0] MemAddress1;
	input [10:0] MemAddress2;
	//internal is the actual ram
	//holds 2048 addresses and each one holds 16 bits
	reg [15:0] internal [0:2047];
	//since inout is a wire outData is used to output the data
	reg [15:0] outData;
	reg [15:0] outData2;
	
	//holds the previous RW to test for a posedge
	//for the write process
	//reg prevRW;
	integer j;
	wire [15:0] data_in;
	wire [15:0] data_in2;
	reg [1:0] counter;
	
	wire [15:0] internalData;
	wire [10:0] internalAddress;
	reg [15:0] internalData1;
	reg [10:0] internalAddress1;
	reg write;
	assign internalData=(OE)? internalData1:16'bz;
	assign internalAddress=internalAddress1;
	memory Mymemory (internalData, internalAddress, clk,write);
	//initialization process
	//puts 0 in all the bits in the RAM
	initial
		begin
					for (j=0; j<2048;j=j+1)
						begin
							internal[j]=16'hffff;
						end
			outData=1'b0;
			outData2=1'b0;
			counter =1'b0;
		end
		
		//if OE changes midway through a write process or read process this resets the counter and exits the previous process
		//always @ (posedge OE or negedge OE) counter<=2'b00;
		//Running always block	
		always @ (posedge clk) begin
		    //First checks to see if this is the correct chip
			if (!CS)
				begin
				    //Reads
					write=1'b0;
					if (!OE) begin
						case (counter)
						2'b00: begin
									counter<=2'b01;
									internalAddress1<=MemAddress1;
									outData<=internalData;
								end
						2'b01: begin
									counter<=2'b00;
									internalAddress1<=MemAddress2;
									outData2<=internalData;
								end
						2'b10: counter<=2'b00;
						2'b11: counter<=2'b00;
						default: counter<=2'b00;
						endcase
					end
					//Writes
					if (OE) begin
						
						case (counter) 
							//2'b00: if (!RW) counter<=2'b01;
							//		 else counter<=2'b00;
							2'b00: if (RW) begin
											write=1'b1;
											internalAddress1<=MemAddress2;
											internalData1<=data_in;
											counter<=2'b10;
									 end else counter<=2'b00;
							2'b10: begin
										write=1'b1;
										internalAddress1<=MemAddress1;
										internalData1<=data_in2;
										counter<=2'b11;
									end
							2'b11: if (!RW) counter<=2'b00;
									else counter<=2'b11;
							default: counter<=2'b00;
						endcase
					end
				end
		end
	
	assign MemData1 = (!OE) ? outData : 16'bz;
	assign data_in = MemData1;
	assign MemData2 = (!OE) ? outData2 : 16'bz;
	assign data_in2 = MemData2;
	//assign MemData1 = (!OE) ? internal[MemAddress1]: 16'bz;
	//assign MemData2 = (!OE) ? internal[MemAddress2]: 16'bz;
	
endmodule

//TESTING
/*
module testBench;
		wire [15:0] MemData1;
	wire [15:0] MemData2;
	//Chip Select(CS), Output Enabled (OE), Read/Write (RW), clock (clk)
	wire CS, OE, RW, clk;
	//Stores the address
	wire [10:0] MemAddress1;
	wire [10:0] MemAddress2;
	
	SRAMmemory my_SRAM (MemData1, MemData2, clk, MemAddress1, MemAddress2,CS, OE, RW);
	
	Tester aTester (MemData1, MemData2, clk, MemAddress1, MemAddress2,CS, OE, RW);
	
	initial
		begin
			$dumpfile ("SRAMmemory.vcd");
			$dumpvars (1,my_SRAM);
		end
endmodule

module Tester (MemData1, MemData2, clk, MemAddress1, MemAddress2,CS, OE, RW);
	inout wire [15:0] MemData1;
	inout wire [15:0] MemData2;
	output reg CS, OE, RW, clk;
	output reg [10:0] MemAddress1;
	output reg [10:0] MemAddress2;
	
	reg [15:0] data22=1'b0;
	reg [15:0] data12=1'b0;
	
	integer i;
	
	parameter stimDelay = 1;
	assign MemData1= (OE) ? data22 : 16'bz;
	assign MemData2= (OE) ? data12 : 16'bz;
	
	initial
		begin
			//$display ("\t clk \t address \t data \t RW \t OE");
			$monitor ("\t clk:%b \t address:%d \t\t data:%d \t RW:%b \t OE:%b",clk,MemAddress1,MemData1,RW,OE);
		end
	initial
		begin*/
		/*
			for(i=0; i<128;i++) begin
				
				#stimDelay clk=1'b1;address=i; RW=1'b1; OE=1'b0;
				#stimDelay clk=1'b0;
			end
		*/
			/*
			CS=1'b0; i=0;
			#stimDelay clk=1'b1;MemAddress1=i; MemAddress2=~MemAddress1; data22=127-i;data12=127-i; RW=1'b0; OE=1'b1;
				#stimDelay clk=1'b0;
				#stimDelay clk=1'b1; RW=1'b1;
				#stimDelay clk=1'b0;
			for(i=0; i<128;i=i+1) begin
				
				#stimDelay clk=1'b1;MemAddress1=i; MemAddress2=~MemAddress1; data22=127-i;data12=127-i; RW=1'b0; OE=1'b1;
				#stimDelay clk=1'b0;
				#stimDelay clk=1'b1; RW=1'b1;
				#stimDelay clk=1'b0;
				#stimDelay clk=1'b1;
				#stimDelay clk=1'b0;
			end
			CS=1'b0; i=0;
			for(i=0; i<128;i=i+1) begin
				
				#stimDelay clk=1'b1;MemAddress1=i; MemAddress2=~MemAddress1; RW=1'b1; OE=1'b0;
				#stimDelay clk=1'b0;
				#stimDelay clk=1'b1;
				#stimDelay clk=1'b0;
				#stimDelay clk=1'b1;
				#stimDelay clk=1'b0;
				#stimDelay clk=1'b1;
				#stimDelay clk=1'b0;
			end
		end
endmodule*/