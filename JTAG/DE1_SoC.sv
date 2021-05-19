module DE1_SoC (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, SW, LEDR, CLOCK_50);
   output logic [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0]  LEDR;
   input  logic [3:0]  KEY;
   input  logic [9:0]  SW;
   input logic CLOCK_50;
	
	// Default values, turns off the HEX displays
	assign HEX0 = 7'b1111111;
	assign HEX1 = 7'b1111111;
	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	
	logic clean_out;
	
	// clean up the tck input before putting it into the JTAG
	input_processing ip (.A(~KEY[0]), .out(clean_out), .clk(CLOCK_50));
	
	// JTAG module
	jtag_top JTAG (.tdi_i(SW[0]), 
						.tms_i(SW[1]), 
						.tck_i(clean_out), 
						.chip_reset(~KEY[2]), 
						.trst_n_i(KEY[3]), 
						.tdo_o(LEDR[0]), 
						.tap_states(LEDR[9:6]));

	
endmodule 

module jtag_top_tb ();
    parameter chain_num = 2;
    parameter chain_select_width = $clog2(chain_num);
    parameter instr_width = chain_select_width + 3;
    //logic 1:fsm
    parameter logic_1_in = 2;
    parameter logic_1_out = 2;
    parameter chain_1_length = logic_1_in + logic_1_out;
    //logic 2: add
    parameter logic_2_in = 2;
    parameter logic_2_out = 1;
    parameter chain_2_length = logic_2_in + logic_2_out;

	//jtag 
    logic tdi_i, tms_i, tck_i, trst_n_i, tdo_o, chip_reset;
    //first logic cloud
    logic [logic_1_in-1:0] system_1_in;
    logic [logic_1_out-1:0] system_1_out;
    //second logic cloud
    logic [logic_2_in-1:0] system_2_in;
    logic [logic_2_out-1:0] system_2_out;

    logic enable;
    logic [3:0] tap_states;

	jtag_top #(
	    .chain_num(chain_num),
	    //logic 1:fsm
	    .logic_1_in(logic_1_in),
	    .logic_1_out(logic_1_out),
	    //logic 2: add
	    .logic_2_in(logic_2_in),
	    .logic_2_out(logic_2_out)
	) jtag (
	    //jtag 
	    .tdi_i,
	    .tms_i,
	    .tck_i,
	    .trst_n_i,
	    .tdo_o,

	    //logic reset signal
	    .chip_reset,
	    //first logic cloud
	    .system_1_in,
	    .system_1_out,
	    //second logic cloud
	    .system_2_in,
	    .system_2_out,
	    .enable,
	    .tap_states
	);

	logic [0:0] tdi_vec [127:0];
	logic [0:0] tms_vec [127:0];
    initial begin
        $readmemb("tdi.txt", tdi_vec);
        $readmemb("tms.txt", tms_vec);
    end

    logic init;
    integer i, j;
    always @(negedge tck_i) begin
    	if (init)
    		tdi_i <= tdi_vec[i][0];
    	else if (enable) begin
    		i++;
    		tdi_i <= tdi_vec[i][0];
    	end else
    		tdi_i <= tdi_i;
    end

    always @(negedge tck_i) begin
    	if (init)
    		tms_i <= tms_vec[j][0];
    	else begin
    		j++;
    		tms_i <= tms_vec[j][0];
    	end

        if (j == 128)
				$stop;
            //$finish;
    end

    parameter period = 10;
    parameter half = period / 2;

    initial begin
        // $vcdpluson;
        i = 0; j = 0;
        trst_n_i = 0;
        chip_reset = 1;
        init = 1;
        tck_i = 1; #half;
        tck_i = 0; #half;
        tck_i = 1; #half;
        tck_i = 0; #half;
        tck_i = 1; #half;
        tck_i = 0; #half;
        tck_i = 1; #half;
        trst_n_i = 1;
        chip_reset = 0;
        init = 0;
        tck_i = 0;
        system_1_in = 2'b01;
        system_2_in = 2'b10;
        repeat (1000) #half tck_i = ~tck_i;
        $display("time out!!!!!!!!!!!!!");
        $display("time out!!!!!!!!!!!!!");
        $display("time out!!!!!!!!!!!!!");
        $display("time out!!!!!!!!!!!!!");
        $display("time out!!!!!!!!!!!!!");
		  $stop;
        // $finish;
    end
endmodule