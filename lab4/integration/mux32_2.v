module mux32_2 (datain1,datain2,select,muxOut);

	input [31:0] datain1, datain2;
	input select;
	output [31:0] muxOut;

	genvar a;
	generate
		for (a=0;a<32;a=a+1) begin :A
			mux2_1 A (.din_0(datain1[a]),.din_1(datain2[a]),.sel(select),.mux_out(muxOut[a]));
		end
	endgenerate
	
endmodule