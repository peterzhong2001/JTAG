// bypass: all ones
// extest: all zeros
// sample/preload: 000...10
// intest: 000...01
// select_bsr: 0,[chain selection],11

module instr_decode #(
    parameter instr_width = 4,
    parameter sel_width = (instr_width - 3))
    (
    input logic reset_n, 
    input logic clk,

    //user-defined instructions: first bit->0 & last two bits->11.
    //effective instr = instr[instr_length-2:2];
    input logic [instr_width-1:0] instr_in,
    output logic [sel_width-1:0] mux_sel,
    output logic sample_preload,
    output logic ex_in_test
    );

    enum bit [2:0] {bypass, extest, sample, intest, select_bsr, bad} instr_type;
    //logic [2:0] instr_type;
    always_comb begin
        case (instr_in)
            '0: instr_type = bypass;
            '1: instr_type = extest;
            {{instr_width-2{1'b0}}, 2'b01}: instr_type = intest;
            {{instr_width-2{1'b0}}, 2'b10}: instr_type = sample;
            default: if ((instr_in[1:0] == 2'b11) && (instr_in[instr_width-1] == 1'b0))
                        instr_type = select_bsr;
                     else
                        instr_type = bad;
        endcase // instr_in
    end

    logic [sel_width-1:0] chain_select, hold_select;
    assign chain_select = instr_in[instr_width-2:2];

    always_ff @(posedge clk or negedge reset_n) begin
        if(~reset_n) begin
            hold_select <= '0;
        end else begin
            if (instr_type == select_bsr)
                hold_select <= chain_select;
            else
                hold_select <= hold_select;
        end
    end

    assign mux_sel = (instr_type == select_bsr) ? chain_select : hold_select;
    assign sample_preload = (instr_type == sample);
    assign ex_in_test = (instr_type == extest) || (instr_type == intest);

endmodule