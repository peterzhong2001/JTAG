module instruction_register #(parameter instr_width = 4) (
    input logic trst_n,
    input logic reset_n,
    input logic clock_ir, 
    input logic update_ir, 
    input logic shift_ir,
    input logic s_i,
    input logic [instr_width-1:0] p_data_i, 
    output logic [instr_width-1:0] p_data_o, 
    output logic s_o
);

    logic [instr_width:0] hold; //1 more bit for holding the result
    
    genvar i;
    generate 
        for (i = 0; i < instr_width; i++) begin: instr_reg
            instruction_cell instr_cell (
                .trst_n(trst_n),
                .reset_n(reset_n),
                .shift_ir(shift_ir),
                .update_ir(update_ir),
                .clock_ir(clock_ir),
                .s_i(hold[i]),
                .s_o(hold[i+1]),
                .p_i(p_data_i[i]),
                .p_o(p_data_o[i])
            );
        end
    endgenerate 
  
  assign hold[0] = s_i;
  assign s_o = hold[instr_width];
  
endmodule