module SRAM_top(data, addr, CS, write, clk);
	inout[31:0] data;
	input[10:0] addr;
	input CS, write, clk;
	
	// Internal storage
	reg[31:0] MDR;
	reg[10:0] MAR;
	reg[15:0] MDR_partial;
	reg[2:0] counter;
	
	// SRAM stuff (For interfacing with an SRAM module that doesn't agree with the rest of the design)
	reg OE, CS_reg;
	wire[15:0] MDR_partial_w; // Registers can't be hooked up to inouts directly
	assign MDR_partial_w = write ? MDR_partial : 16'bz;
	
	SRAM sram(MDR_partial_w, MAR, CS_reg, OE, WE);
	assign WE = write ? clk : 1'b1;
	
	always @(posedge clk) begin
		if (CS) begin // if the module is disabled
			counter = 3'b000;
		end else begin	// Otherwise, actual logic
			if (write) begin
				case(counter) // write the address and data values into the MAR/MDR
					3'b100: begin
						MDR = data;
						MAR = addr;
						CS_reg = 0;
						OE = 1'b1;
						
						counter = 3'b101;
					end
					3'b101: begin
						MDR_partial = MDR[31:16];	// Load in half of the data
						counter = 3'b110;
					end
					3'b110: begin 
						MDR_partial = MDR[15:0];	// Load in second half of the data
						MAR = ~MAR; 				// Update the memory address
						counter = 3'b111;
					end
					3'b111: begin
						CS_reg = 1'b1; 
						if (MAR != addr)
							counter = 3'b100;
						else
							counter = counter;
						
					end
					default: counter = 3'b100;
				endcase
			end else begin
				case(counter)
					3'b000: begin
						MAR = addr;				// Load the correct address into the MAR
						OE = 0;
						CS_reg = 0;
						counter = 3'b001;
					end
					3'b001: begin
						MDR[31:16] = MDR_partial_w; // Read in the first half of the data
						MAR = ~MAR;					// Update memory address
						counter = 3'b010;
					end
					3'b010: begin
						MDR[15:0] = MDR_partial_w; // Read in the second half of the data
						counter = 3'b011;
					end
					3'b011: begin 
						if (MAR != addr)
							counter = 3'b000;
						else
							counter = counter;
					end
					default: counter = 3'b000;
				endcase
			end
		end
	end
	
	assign data = (~write & ~CS) ? MDR : 32'bz; 
	
endmodule