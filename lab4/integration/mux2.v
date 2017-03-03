module mux2(out, in, select);
	output[1:0] out;
	input in, select;
	
	and and1(out[1], in, select);
	
	wire select_bar;
	not n1(select_bar, select);
	
	and and2(out[0], in, select_bar);
endmodule