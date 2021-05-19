module singleBSC (
	// system in and out
	input logic p_i,
	output logic p_o,

	// serial in and out
	input logic s_i,
	output logic s_o,

	// control signals
	input logic shift_dr,
	input logic clock_dr,
	input logic update_dr,
	input logic mode
	);
	
	logic clock_reg_in, update_reg_in, update_reg_out;

	assign clock_reg_in = shift_dr ? s_i : p_i;

	always_ff @(posedge clock_dr)
		update_reg_in <= clock_reg_in;

	always_ff @(posedge update_dr)
		update_reg_out <= update_reg_in;

	assign s_o = update_reg_in;
	assign p_o = mode ? update_reg_out : p_i;
	
endmodule