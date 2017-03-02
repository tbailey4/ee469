module memory (data, address, clk, write);

	inout [15:0] data;
	input [10:0] address;
	input clk;
	input write;
	
	reg [15:0] internal [0:2047];
	
	integer j;
		initial
		begin
					for (j=0; j<2048;j=j+1)
						begin
							internal[j]=16'hffff;
						end
			//outData=1'b0;
			//outData2=1'b0;
		end
	
	reg [15:0] inputData;
	reg [15:0] outputData;
	
	always @ (negedge clk) begin
		if (write) internal[address]=data;
		else outputData=internal[address];
	end
	
	assign data=(!write) ? outputData:16'bz;
	
endmodule