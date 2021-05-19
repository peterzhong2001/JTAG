module test_fsm(clk, reset, in, out);
	input logic clk;
	input logic reset;
	input logic [1:0] in;
	output logic [1:0] out;

	logic [1:0] ps, ns;
	always_ff @(posedge clk) begin
		if(reset) begin
			ps <= 2'b00;
		end else begin
			ps <= ns;
		end
	end

	always_comb begin
		case(ps)
			2'b00: 	if (in[0] & in[1])
						ns = 2'b01;
					else
						ns = 2'b00;
			2'b01: 	if (in[0] & in[1])
						ns = 2'b10;
					else
						ns = 2'b01;
			2'b10: 	if (in[0] & in[1])
						ns = 2'b11;
					else
						ns = 2'b10;
			2'b11: 	if (in[0] & in[1])
						ns = 2'b00;
					else
						ns = 2'b11;
		endcase
	end

	assign out = ps;
endmodule