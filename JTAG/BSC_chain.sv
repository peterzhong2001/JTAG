module BSC_chain #(parameter chain_length = 4) (
  input logic clock_dr, 
  input logic update_dr, 
  input logic shift_dr, 
  input logic enable,
  input logic mode, 
  input logic s_i,
  input logic [chain_length-1:0] p_data_i, 
  output logic [chain_length-1:0] p_data_o, 
  output logic s_o);

  logic [chain_length:0] hold; //1 more bit for holding the result
	
  genvar i;
  generate 
		for (i = 0; i < chain_length; i++) begin: bs_chain
			singleBSC bs_cell (
        .shift_dr(shift_dr & enable),
        .update_dr(update_dr & enable),
        .clock_dr(clock_dr & enable),
        .mode(mode),
        .s_i(hold[i]),
        .s_o(hold[i+1]),
        .p_i(p_data_i[i]),
        .p_o(p_data_o[i])
        );
		end
	endgenerate 
  
  assign hold[0] = s_i;
  assign s_o = hold[chain_length];
  
endmodule