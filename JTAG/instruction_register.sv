module instruction_register #(
    parameter instr_width = 4,
    parameter sel_width = (instr_width - 3))
    (
    input logic trst_n,
    input logic reset_n,
    input logic clock_ir, 
    input logic update_ir, 
    input logic shift_ir,
    input logic s_i,
	 input logic [sel_width+1:0] instr_decode_out, 
    input logic [instr_width-1:0] p_data_i, 
	 output logic [instr_width-1:0] instr_decode_in, 
    output logic [sel_width+1:0] p_data_o, 
    output logic s_o
);

    logic [instr_width:0] hold; //1 more bit for holding the result
    
    genvar i;
    generate 
        for (i = 0; i < instr_width; i++) begin : instr_reg
            instruction_cell instr_cell (
                .shift_ir(shift_ir),
                .clock_ir(clock_ir),
                .s_i(hold[i]),
                .s_o(hold[i+1]),
                .p_i(p_data_i[i]),
                .p_o(instr_decode_in[i])
            );
			end
    endgenerate 
	 
	 genvar j;
	 generate
	 			for (j = 0; j < (sel_width+2); j++) begin : update_reg
				update_ir_cell ir_cell (
					 .trst_n(trst_n),
                .reset_n(reset_n),
                .update_ir(update_ir),
                .p_i(instr_decode_out[j]),
                .p_o(p_data_o[j])
				);
        end
	endgenerate
  
  assign hold[0] = s_i;
  assign s_o = hold[instr_width];
  
endmodule