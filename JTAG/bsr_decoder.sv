module bsr_decoder #(
	 parameter chain_num = 2,
    parameter sel_width = $clog2(chain_num))
    (
    input logic [sel_width-1:0] sel, 
    input logic clk,
	 input logic reset_n,

    output logic [chain_num-1:0] bsr_decoder_out
    );
	
	 always_ff @(posedge clk) begin
		if (~reset_n)
			bsr_decoder_out <= '0;
		else
			bsr_decoder_out <= {{chain_num-1{1'b0}}, 1'b1} << sel;
	 end
	 
endmodule 