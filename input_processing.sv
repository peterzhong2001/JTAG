// clean up button press and make user's button push 1 clock cycle long

module input_processing (A, out, clk);

	input logic A, clk;
	output logic out;
	
	logic buffer, in;
	
	// put the input logic through 2 D_FFs to clean up
	always_ff @(posedge clk) begin
		buffer <= A;
		in <= buffer;
	end
	
	enum {none, hold} ps, ns;
	
	// Next state logic
	always_comb begin
		case(ps)
			none: if (in) ns = hold;
					else ns = none;
			hold: if (in) ns = hold;
					else ns = none;
		endcase
	end
	
	// Output logic
	always_comb begin
		case (ps)
			none: if (in) out = 1'b1;
					else out = 1'b0;
			hold: out = 1'b0;
		endcase
	end
	
	// DFFs
	always_ff @(posedge clk) begin
			ps <= ns;
	end
endmodule 