module SRAM(data, addr, CS, OE, WE);
	inout [15:0] data;
	input[10:0] addr;
	input CS, OE, WE; // Ouput enable and WEite enable
	
	reg [15:0]memory[2047:0];
	
	// Write Sequence
	always @(posedge WE) begin
		if (~CS & OE) begin // These are active low
			memory[addr] = data;
		end
	end
	
	// Load in values
	initial begin
		$readmemh("data.txt", memory);
		$display("INITIALIZING");
	end
	
	assign data =  ~OE ? memory[addr] : 16'bz;
endmodule