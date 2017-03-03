module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
 output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
 output logic [9:0] LEDR;
 input logic CLOCK_50;
 input logic [3:0] KEY;
 input logic [9:0] SW;
 
 
 // Generate clk off of CLOCK_50, whichClock picks rate.
 logic [31:0] clk;
 parameter whichClock = 21;
 //logic timer;
 
 integration pc (.clk(clk[8]), .fastclk(clk[0]), .rst(KEY[3]) , .KEY(KEY[0]));
 clock_divider divided(.clock(CLOCK_50),.divided_clocks(clk));
endmodule

module clock_divider (clock, divided_clocks);
 input logic clock;
 output logic [31:0] divided_clocks;

 initial
	divided_clocks = 0;
 always_ff @(posedge clock)
	divided_clocks = divided_clocks + 1;
endmodule
