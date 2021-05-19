module instruction_cell (
    // system in and out
    input logic p_i,
    output logic p_o,

    // serial in and out
    input logic s_i,
    output logic s_o,

    // control signals
    input logic shift_ir,
    input logic clock_ir
    );
    
    logic clock_reg_in;

    assign clock_reg_in = shift_ir ? s_i : p_i;

    always_ff @(posedge clock_ir) begin
        s_o <= clock_reg_in;
		  p_o <= clock_reg_in;
	 end
endmodule