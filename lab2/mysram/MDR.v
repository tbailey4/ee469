module MDR (data,MemData1,MemData2,OE,clk);
	inout [31:0] data;
	inout [15:0] MemData1;
	inout [15:0] MemData2;
	input OE;
	input clk;
	/*
	reg [15:0] internal1;
	reg [15:0] internal2;
	reg [31:0] internalfull;
	
	always @ (posedge clk)
		begin
			//if OE high, pass the memory data to data 
			if (OE) begin
				internal1=data[31:16];
				internal2=data[15:0];
			end
			//if OE low, pass data to memory data
			else begin
				internal1=MemData1;
				internal2=MemData2;
			end
			
		end
	
	assign data[31:16]=(!OE)?internal1:16'bz;
	assign data[15:0]=(!OE)?internal2:16'bz;
	assign MemData1=(OE)?internal1:16'bz;
	assign MemData2=(OE)?internal2:16'bz;
	*/
	
	assign data[31:16]=(!OE)?MemData1:16'bz;
	assign data[15:0]=(!OE)?MemData2:16'bz;
	assign MemData1=(OE)?data[31:16]:16'bz;
	assign MemData2=(OE)?data[15:0]:16'bz;
endmodule