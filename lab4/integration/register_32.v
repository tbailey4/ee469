module register_32(read2, read1, D, read2_en, read1_en, write, clk, rst);
	output[31:0] read2, read1;
	input[31:0] D;
	input read2_en, read1_en, write, clk, rst;
	
	// Generate Wires
	genvar i;
	wire[31:0] q_raw, d_lines;
	
	generate
		for (i = 0; i < 32; i = i + 1) begin : dff_array
			demux2 mux(d_lines[i], {D[i], q_raw[i]}, write);
			DFlipFlop dff(q_raw[i], , d_lines[i], clk, rst);
			bufif1 bf2(read2[i], q_raw[i], read2_en);
			bufif1 bf1(read1[i], q_raw[i], read1_en);
		end
	endgenerate
endmodule