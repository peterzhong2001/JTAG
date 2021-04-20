// clean up the output of the button for tck
module debouncer (in, out, clk);

	input logic in, clk;
	output logic out;
	
	logic buffer;
	
	D_FF(.q(buffer), .d(in), .clk);
	D_FF(.q(out), .d(buffer), .clk);

endmodule 