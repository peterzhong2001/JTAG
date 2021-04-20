module bsr_mux #(parameter chain_num = 2, sel_width = $clog2(chain_num)) (
    input logic [chain_num-1:0] bsr_so,
    input logic [sel_width-1:0] sel,
    output logic scan_reg_out
);

    // decode selection
    logic [chain_num-1:0] one_hot_select;

    if (chain_num == 1) begin
        logic unused;
        assign unused = sel;
        assign one_hot_select = 1'b1;
    end
    else begin
        assign one_hot_select = (1'b1 << sel);
    end

    // mux select
    logic [chain_num-1:0] data_masked;
    genvar i;
    for (i = 0; i < chain_num; i++) begin : mask
        assign data_masked[i] = bsr_so[i] & one_hot_select[i];
    end

    assign scan_reg_out = | data_masked;
endmodule