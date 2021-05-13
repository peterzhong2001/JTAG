module jtag_top #(
    parameter chain_num = 2,
    parameter chain_select_width = $clog2(chain_num),
    parameter instr_width = chain_select_width + 3,
    //logic 1:fsm
    parameter logic_1_in = 2,
    parameter logic_1_out = 2,
    parameter chain_1_length = logic_1_in + logic_1_out,
    //logic 2: add
    parameter logic_2_in = 2,
    parameter logic_2_out = 1,
    parameter chain_2_length = logic_2_in + logic_2_out)
(
    //jtag input
    input logic tdi_i,
    input logic tms_i,
    input logic tck_i,
    input logic trst_n_i,
    output logic tdo_o,

    //logic reset signal
    input logic chip_reset,
    //first logic cloud
    input logic [logic_1_in-1:0] system_1_in,
    output logic [logic_1_out-1:0] system_1_out,
    //second logic cloud
    input logic [logic_2_in-1:0] system_2_in,
    output logic [logic_2_out-1:0] system_2_out,

    //debug and testbench
    output logic enable,
    output logic [3:0] tap_states
);

/*********************tap_state_machine********************/
    // control signals to data register
    logic clock_dr_tap, shift_dr, update_dr_tap;
    // control signals to instruction register
    logic clock_ir, shift_ir, update_ir, reset_n_ir;
    // control signals to tdo
    logic select_tdo, tdo_en;
    logic [3:0] tap_state;

    tap_state_machine tap_controller (
        .trst_n(trst_n_i),
        .tck(tck_i),
        .tms(tms_i),
        .clock_dr(clock_dr_tap),
        .update_dr(update_dr_tap),
        .shift_dr(shift_dr),
        .reset_n_ir(reset_n_ir),
        .clock_ir(clock_ir),
        .update_ir(update_ir),
        .shift_ir(shift_ir),
        .select_tdo(select_tdo),
        .tdo_en(tdo_en),
        .tap_state(tap_state)
    );

/********************instruction register********************/
    logic [instr_width-1:0] instr;
    logic instr_reg_out;

    instruction_register #(.instr_width(instr_width)) 
        instr_reg (
            .trst_n(trst_n_i),
            .reset_n(reset_n_ir),
            .clock_ir(clock_ir),
            .update_ir(update_ir),
            .shift_ir(shift_ir),
            .s_i(tdi_i),
            .p_data_i({instr_width{1'b0}}),
            .p_data_o(instr),
            .s_o(instr_reg_out)
        );

/********************instruction decoder********************/
    logic [chain_select_width-1:0] chain_sel;
    logic sample_preload, ex_in_test, clock_dr, update_dr;

    instr_decode #(.instr_width(instr_width),
                   .sel_width(chain_select_width)) 
        ins_decoder(
            .reset_n(trst_n_i),
            .clk(tck_i),
            .instr_in(instr),
            .mux_sel(chain_sel),
            .sample_preload(sample_preload),
            .ex_in_test(ex_in_test)
        );
    assign clock_dr = clock_dr_tap & (sample_preload | ex_in_test);
    assign update_dr = update_dr_tap & (sample_preload | ex_in_test);

/********************chain select********************/
    logic [chain_num-1:0] chain_so;
    logic scan_reg_out, tdo_temp;

    bsr_mux #(.chain_num(chain_num),
              .sel_width(chain_select_width))
        bsr_select(
            .sel(chain_sel),
            .bsr_so(chain_so),
            .scan_reg_out(scan_reg_out)
        );

/********************BSC mode********************/
    logic mode;
    //assign mode = ex_in_test ? 1'b1 : 1'b0;
    always_ff @(posedge update_dr or negedge trst_n_i) begin
        if(~trst_n_i) begin
            mode <= 1'b0;
        end else begin
            if (ex_in_test)
                mode <= ~mode;
            else
                mode <= 1'b0;
        end
    end

    assign tdo_o = tdo_en ? select_tdo ? instr_reg_out : scan_reg_out : 1'bz;
    // always_ff @(negedge tck_i or negedge trst_n_i) begin
    //     if(~trst_n_i) begin
    //         tdo_o <= 1'bz;
    //     end else begin
    //         tdo_o <= tdo_temp;
    //     end
    // end

/********************generate scan chain********************/
    logic [logic_1_in-1:0] toChip_one;
    logic [logic_1_out-1:0] fromChip_one;
    logic [chain_1_length-1:0] pIN_1, pOUT_1;
    assign pIN_1 = {fromChip_one, system_1_in};
    assign toChip_one = pOUT_1[logic_1_in-1:0];
    assign system_1_out = pOUT_1[chain_1_length-1:logic_1_in];


    logic [chain_2_length-1:0] pIN_2, pOUT_2;
    logic [logic_2_in-1:0] toChip_two;
    logic [logic_2_out-1:0] fromChip_two;
    assign pIN_2 = {fromChip_two, system_2_in};
    assign toChip_two = pOUT_2[logic_2_in-1:0];
    assign system_2_out = pOUT_2[chain_2_length-1:logic_2_in];

    BSC_chain #(.chain_length(chain_1_length))
        logic_one (
            .clock_dr(clock_dr), 
            .update_dr(update_dr), 
            .shift_dr(shift_dr), 
            .mode(mode), 
            .s_i(tdi_i),
            .p_data_i(pIN_1), 
            .p_data_o(pOUT_1), 
            .s_o(chain_so[0])
         );

    BSC_chain #(.chain_length(chain_2_length))
        logic_two (
            .clock_dr(clock_dr), 
            .update_dr(update_dr), 
            .shift_dr(shift_dr), 
            .mode(mode), 
            .s_i(tdi_i),
            .p_data_i(pIN_2), 
            .p_data_o(pOUT_2), 
            .s_o(chain_so[1])
         );

    test_fsm fms0 (
        .clk  (tck_i),
        .reset(chip_reset),
        .in   (toChip_one),
        .out  (fromChip_one)
    );

    test_ands and0 (
        .in(toChip_two),
        .out(fromChip_two)
    );

    assign enable = tdo_en;
    assign tap_states = tap_state;
endmodule