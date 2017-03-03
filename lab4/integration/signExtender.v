//`include "mux2_1.v"

module signExtender (outputNum,inputNum);

	input [15:0]inputNum;
	wire [31:0] tempNum;
	output [31:0] outputNum;
	
	genvar i;
	generate
		for (i=16;i<32;i=i+1) begin :EXTEND
			mux2_1 EXTEND1 (.din_0(1'b0),.din_1(1'b1),.sel(inputNum[15]),.mux_out(tempNum[i]));
		end
	endgenerate
	
	assign tempNum[15:0]=inputNum;
	
	assign outputNum=tempNum;


endmodule
