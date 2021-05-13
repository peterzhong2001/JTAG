module update_ir_cell (
    input logic trst_n,

    // parallel in and out
    input logic p_i,
    output logic p_o,

    // control signals
    input logic reset_n,
    input logic update_ir
    );

    always_ff @(posedge update_ir or negedge reset_n or negedge trst_n) begin
        if (~reset_n)
            p_o <= 1'b0;
        else if (~trst_n)
            p_o <= 1'b0;
        else
            p_o <= p_i;
    end
endmodule