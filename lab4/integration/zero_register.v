module zero_register(read2, read1, D, read2_en, read1_en, clk, rst);
	output[31:0] read2, read1;
	input[31:0] D;
	input read2_en, read1_en, clk, rst;
	
	// Generate Wires
	genvar i;
	
	generate
		for (i = 0; i < 32; i = i + 1) begin : dff_array
			bufif1 bf2(read2[i], 0, read2_en);
			bufif1 bf1(read1[i], 0, read1_en);
		end
	endgenerate
	
endmodule