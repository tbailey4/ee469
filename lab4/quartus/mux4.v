module mux4(out, in, select);
	output[3:0] out;
	input[1:0] select;
	input in;
	
	wire[1:0] inter;
	
	// Layer0
	mux2 m1(inter, in, select[1]);
	
	// Layer1
	mux2 m2(out[3:2], inter[1], select[0]);
	mux2 m3(out[1:0], inter[0], select[0]);
endmodule