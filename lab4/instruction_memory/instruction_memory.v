module instruction_memory ( instructional_data,addr,addr, clk,write_enable);
	input [6:0] addr;
	input clk, write_enable;
	//input [31:0] write_data;
	inout [31:0] instructional_data;
	
	reg [31:0] internalData [127:0];
	reg [31:0] outData;
	
	//write data
	always @(negedge clk) begin
		if (write_enable) begin
			internalData[addr]=instructional_data;
		end
	end
	
	always @ (posedge clk) begin
		if (!write_enable) begin
			outData = internalData[addr];
		end
	end
	
	assign instructional_data=(!write_enable) ? outData:32'bZ;

endmodule