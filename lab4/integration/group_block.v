module group_block(group_g, group_p, sum, a, b, c_in);
	output group_g, group_p;
	output[3:0] sum;
	input[3:0] a, b;
	input c_in;
	
	wire[3:0] p, g, sub_group_g;	// Non group generate and propagate lines
	
	// Individual generate and propagate
	assign g = a & b;
	assign p = a ^ b;	// This is not true propagate logic, so generate must be used too
	
	// Group generate and propagate
	assign group_p = &p;
	assign sub_group_g[0] = p[0] & c_in | g[0];
	assign sub_group_g[1] = p[1] & sub_group_g[0] | g[1];
	assign sub_group_g[2] = p[2] & sub_group_g[1] | g[2];
	assign sub_group_g[3] = p[3] & sub_group_g[2] | g[3];
	
	assign group_g = sub_group_g[3];
	
	// Actual sum
	assign sum[0] = c_in ^ p[0];
	assign sum[1] = sub_group_g[0] ^ p[1];
	assign sum[2] = sub_group_g[1] ^ p[2];
	assign sum[3] = sub_group_g[2] ^ p[3];
	
endmodule