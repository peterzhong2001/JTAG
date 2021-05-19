// This tap controller is based on the example in IEEE standard for
// Test Access Port and Boundary-Scan Architecture, 2013
module tap_state_machine (
	// input control signals
	input logic trst_n,
	input logic tck,
	input logic tms,

	// control signals to data register
	output logic clock_dr,
	output logic update_dr,
	output logic shift_dr,

	// control signals to instruction register
	output logic reset_n_ir,
	output logic clock_ir,
	output logic update_ir,
	output logic shift_ir,

	// select DR or IR or Bypass
	output logic select_tdo,
	output logic tdo_en,
	output logic bypass,
	
	// debug port, tap_state
	output logic [3:0] tap_state
	);

	// TAP state machine
	enum bit [3:0] {reset 		= 4'hF,
					idle 		= 4'hC,
					DR_scan		= 4'h7,
					capture_DR	= 4'h6,
					shift_DR 	= 4'h2,
					exit1_DR 	= 4'h1,
					pause_DR 	= 4'h3,
					exit2_DR 	= 4'h0,
					update_DR 	= 4'h5,
					IR_scan 	= 4'h4,
					capture_IR 	= 4'hE,
					shift_IR 	= 4'hA,
					exit1_IR 	= 4'h9,
					pause_IR 	= 4'hB,
					exit2_IR 	= 4'h8,
					update_IR 	= 4'hD
					} ps, ns;

	always_comb begin
		case(ps)
			reset: 		if (tms) ns = reset;
				   		else	 ns = idle;
			idle: 	 	if (tms) ns = DR_scan;
				  		else	 ns = idle;

			// scan data register
			DR_scan: 	if (tms) ns = IR_scan;
				  	 	else	 ns = capture_DR;
			capture_DR: if (tms) ns = exit1_DR;
						else	 ns = shift_DR;
			shift_DR: 	if (tms) ns = exit1_DR;
						else	 ns = shift_DR;
			exit1_DR: 	if (tms) ns = update_DR;
						else	 ns = pause_DR;
			pause_DR: 	if (tms) ns = exit2_DR;
						else	 ns = pause_DR;
			exit2_DR: 	if (tms) ns = update_DR;
						else	 ns = shift_DR;
			update_DR: 	if (tms) ns = DR_scan;
						else	 ns = idle;

			// scan instruction register
			IR_scan: 	if (tms) ns = reset;
				  	 	else	 ns = capture_IR;
			capture_IR: if (tms) ns = exit1_IR;
						else	 ns = shift_IR;
			shift_IR: 	if (tms) ns = exit1_IR;
						else	 ns = shift_IR;
			exit1_IR: 	if (tms) ns = update_IR;
						else	 ns = pause_IR;
			pause_IR: 	if (tms) ns = exit2_IR;
						else	 ns = pause_IR;
			exit2_IR: 	if (tms) ns = update_IR;
						else	 ns = shift_IR;
			update_IR: 	if (tms) ns = DR_scan;
						else	 ns = idle;

			default: ns = reset;
		endcase
	end
	
	always_ff @(posedge tck or negedge trst_n) begin
		if (~trst_n)
			ps <= reset;
		else
			ps <= ns;
	end

	// control signals to instruction register
	always_ff @(negedge tck or negedge trst_n) begin
		if (~trst_n) begin
			reset_n_ir <= 1'b0;
			shift_ir <= 1'b0;
		end else begin
			if (ps == reset)
				reset_n_ir <= 1'b0;
			else
				reset_n_ir <= 1'b1;
				
			if (ps == shift_IR)
				shift_ir <= 1'b1;
			else
				shift_ir <= 1'b0;
		end
	end
	assign clock_ir = ~(((ps == capture_IR) || (ps == shift_IR)) & ~tck);
	assign update_ir = (ps == update_IR) & ~tck;

	// control signals to data register
	always_ff @(negedge tck or negedge trst_n) begin
		if (~trst_n)
			shift_dr <= 1'b0;
		else if (ps == shift_DR)
			shift_dr <= 1'b1;
		else
			shift_dr <= 1'b0;
	end
	assign clock_dr = ~(((ps == capture_DR) || (ps == shift_DR)) & ~tck);
	assign update_dr = (ps == update_DR) & ~tck;

	// control signals to tdo
	always_ff @(negedge tck or negedge trst_n) begin
		if (~trst_n)
			tdo_en <= 1'b0;
		else if ((ps == shift_DR) || (ps == shift_IR))
			tdo_en <= 1'b1;
		else
			tdo_en <= 1'b0;
	end
	assign select_tdo = ps[3];
	assign bypass = (ps == reset);
	
	assign tap_state = ps;
endmodule