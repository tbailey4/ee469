module mux32(out, in, select);
	output[31:0] out;
	input[4:0] select;
	input in;
	
	// Layer Interconnects
	wire[1:0] i0;
	
	// Layer 0
	mux2 m0(i0, in, select[4]);
	
	// Layer 1
	mux16 m00(out[31:16], i0[1], select[3:0]);
	mux16 m01(out[15:0], i0[0], select[3:0]);
endmodule