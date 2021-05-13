module instruction_cell (
    input logic trst_n,

    // system in and out
    input logic p_i,
    output logic p_o,

    // serial in and out
    input logic s_i,
    output logic s_o,

    // control signals
    input logic reset_n,
    input logic shift_ir,
    input logic clock_ir,
    input logic update_ir
    );
    
    logic clock_reg_in, update_reg_in;

    assign clock_reg_in = shift_ir ? s_i : p_i;

    always_ff @(posedge clock_ir)
        update_reg_in <= clock_reg_in;

    always_ff @(posedge update_ir or negedge reset_n or negedge trst_n) begin
        if (~reset_n)
            p_o <= 1'b0;
        else if (~trst_n)
            p_o <= 1'b0;
        else
            p_o <= update_reg_in;
    end

    assign s_o = update_reg_in;
endmodule