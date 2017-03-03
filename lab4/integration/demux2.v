module demux2(out, in, select);
	output out;
	input[1:0] in;
	input select;
	
	wire[1:0] and_out;
	
	and and0(and_out[0], in[0], ~select);
	and and1(and_out[1], in[1], select);
	
	or or0(out, and_out[1], and_out[0]);
endmodule