module mux16(out, in, select);
	output[15:0] out;
	input[3:0] select;
	input in;
	
	// Interconnects
	wire[3:0] i0;
	
	// Layer 0
	mux4 m0(i0, in, select[3:2]);
	
	// Layer 1
	mux4 m10(out[15:12], i0[3], select[1:0]);
	mux4 m11(out[11:8], i0[2], select[1:0]);
	mux4 m12(out[7:4], i0[1], select[1:0]);
	mux4 m13(out[3:0], i0[0], select[1:0]);
endmodule