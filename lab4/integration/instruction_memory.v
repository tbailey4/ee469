module instruction_memory ( instruction,addr, clk,write_enable);
	input [6:0] addr;
	input clk, write_enable;
	//input [31:0] write_data;
	inout [31:0] instruction;
	
	reg [31:0] internalData [127:0];
	reg [31:0] outData;
	
	//write data at neg edge
	//should make it more stable for writing
	always @(negedge clk) begin
		if (write_enable) begin
			internalData[addr]=instruction;
		end
	end
	//read data at pos edge
	always @ (posedge clk) begin
		if (!write_enable) begin
			outData = internalData[addr];
		end
	end
	
	assign instruction=(!write_enable) ? outData:32'bZ;

endmodule