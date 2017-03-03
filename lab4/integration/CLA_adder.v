`include "group_block.v"

// 16-bit, radix-4 CLA adder
// If sub = 1, sum = a - b
// Z = zero, V = overflow, C = carry out, N = negative
module CLA_adder(V, C, sum, a, b, sub);
	output V, C;
	output[15:0] sum;
	input[15:0] a, b;
	input sub;
	
	// Prepare operands
	wire[15:0] b_input;	// The b operand must be inverted in the case of subtraction
	assign b_input = sub ? ~b : b;
	
	// Create the CLA sub-block interconnects
	wire[3:0] g, p, c_out;
	
	// Lay down the CLA sub-blocks
	group_block block0(g[0], p[0], sum[3:0], a[3:0], b_input[3:0], sub);	// Carry in is set to 1 in the case of subtraction
	group_block block1(g[1], p[1], sum[7:4], a[7:4], b_input[7:4], c_out[0]);
	group_block block2(g[2], p[2], sum[11:8], a[11:8], b_input[11:8], c_out[1]);
	group_block block3(g[3], p[3], sum[15:12], a[15:12], b_input[15:12], c_out[2]);
	
	// Construct interconnect logic
	assign c_out[0] = g[0] | (sub & p[0]);
	assign c_out[1] = g[1] | (c_out[0] & p[1]);
	assign c_out[2] = g[2] | (c_out[1] & p[2]);
	assign c_out[3] = g[3] | (c_out[2] & p[3]);
	
	// Flags
	assign V = (b_input[15] & ~a[15] & (~sum[15])) | ((~b_input[15]) & (~a[15]) & sum[15]);
	assign C = c_out[3];
	
endmodule