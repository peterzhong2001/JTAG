`define chain_number 1 //set to 1 when chain_num = 1. Otherwise 0.

module bsr_mux #(parameter chain_num = 2, sel_width = $clog2(chain_num)) (
    input logic [chain_num-1:0] bsr_so,
    input logic [sel_width-1:0] sel,
    output logic scan_reg_out
);

    // decode selection
    logic [chain_num-1:0] one_hot_select;

	 `ifdef chain_number
        assign one_hot_select = {{chain_num-1{1'b0}}, 1'b1} << sel;
    `endif
	 
//    if (chain_num == 1) begin
//        logic unused;
//        assign unused = sel;
//        assign one_hot_select = 1'b1;
//    end
//    else begin
//        assign one_hot_select = (1'b1 << sel);
//    end

    // mux select
    logic [chain_num-1:0] data_masked;
    genvar i;
	 generate
		for (i = 0; i < chain_num; i++) begin : mask
			assign data_masked[i] = bsr_so[i] & one_hot_select[i];
		end
	 endgenerate

    assign scan_reg_out = | data_masked;
endmodule 