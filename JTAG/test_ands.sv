module test_ands(in, out);
	input logic [1:0] in;
	output logic out;

    assign out = in[0] & in[1];

endmodule
