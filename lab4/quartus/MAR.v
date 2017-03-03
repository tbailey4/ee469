module MAR (inputAddress,MemAddress1,MemAddress2,clk);

	input [10:0] inputAddress;
	input clk;
	output [10:0] MemAddress1;
	output [10:0] MemAddress2;
	
	reg [10:0]internalOutput1;
	reg [10:0]internalOutput2;
	
	always @(posedge clk)
		begin
			internalOutput1 <= inputAddress;
			internalOutput2 <= ~inputAddress;
		end
		
	assign MemAddress1=internalOutput1;
	assign MemAddress2=internalOutput2;

endmodule