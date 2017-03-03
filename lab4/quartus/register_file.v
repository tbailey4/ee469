

module register_file(read2_data, read1_data, read2_addr, 
					read1_addr, write_addr, write_data, write_en, clk, rst);
	output[31:0] read2_data, read1_data;
	input[31:0] write_data;
	input[4:0] read2_addr, read1_addr, write_addr;
	input write_en, clk, rst;
	
	// Register Grid Interconnects
	wire[31:0] write_raw;					// Ungated/clocked one-hot write inputs
	wire[31:0] read2_en, read1_en;			// One-hot read enable lines
	
	// Multiplexing
	mux32 writeMux(write_raw, write_en, write_addr);
	mux32 read2Mux(read2_en, 1'b1, read2_addr);
	mux32 read1Mux(read1_en, 1'b1, read1_addr);
	
	// Grid generate
	genvar i;
	
	generate
		for (i = 0; i < 31; i = i + 1) begin : register_grid // Does not generate final register
			register_32 wordLine(read2_data, read1_data, write_data, read2_en[i], read1_en[i], write_raw[i], clk, rst);
		end
	endgenerate
	
	zero_register final_reg(read2_data, read1_data, write_data, read2_en[31], read1_en[31], , rst);
endmodule