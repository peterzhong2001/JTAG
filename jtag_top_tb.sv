//module jtag_top_tb ();
//    parameter chain_num = 2;
//    parameter chain_select_width = $clog2(chain_num);
//    parameter instr_width = chain_select_width + 3;
//    //logic 1:fsm
//    parameter logic_1_in = 2;
//    parameter logic_1_out = 2;
//    parameter chain_1_length = logic_1_in + logic_1_out;
//    //logic 2: add
//    parameter logic_2_in = 2;
//    parameter logic_2_out = 1;
//    parameter chain_2_length = logic_2_in + logic_2_out;
//
//	//jtag 
//    logic tdi_i, tms_i, tck_i, trst_n_i, tdo_o, chip_reset;
//    //first logic cloud
//    logic [logic_1_in-1:0] system_1_in;
//    logic [logic_1_out-1:0] system_1_out;
//    //second logic cloud
//    logic [logic_2_in-1:0] system_2_in;
//    logic [logic_2_out-1:0] system_2_out;
//
//    logic enable;
//    logic [3:0] tap_states;
//
//	jtag_top #(
//	    .chain_num(chain_num),
//	    //logic 1:fsm
//	    .logic_1_in(logic_1_in),
//	    .logic_1_out(logic_1_out),
//	    //logic 2: add
//	    .logic_2_in(logic_2_in),
//	    .logic_2_out(logic_2_out)
//	) jtag (
//	    //jtag 
//	    .tdi_i,
//	    .tms_i,
//	    .tck_i,
//	    .trst_n_i,
//	    .tdo_o,
//
//	    //logic reset signal
//	    .chip_reset,
//	    //first logic cloud
//	    .system_1_in,
//	    .system_1_out,
//	    //second logic cloud
//	    .system_2_in,
//	    .system_2_out,
//	    .enable,
//	    .tap_states
//	);
//
//	logic [0:0] tdi_vec [127:0];
//	logic [0:0] tms_vec [127:0];
//    initial begin
//        $readmemb("tdi.txt", tdi_vec);
//        $readmemb("tms.txt", tms_vec);
//    end
//
//    logic init;
//    integer i, j;
//    always @(negedge tck_i) begin
//    	if (init)
//    		tdi_i <= tdi_vec[i][0];
//    	else if (enable) begin
//    		i++;
//    		tdi_i <= tdi_vec[i][0];
//    	end else
//    		tdi_i <= tdi_i;
//    end
//
//    always @(negedge tck_i) begin
//    	if (init)
//    		tms_i <= tms_vec[j][0];
//    	else begin
//    		j++;
//    		tms_i <= tms_vec[j][0];
//    	end
//
//        if (j == 128)
//            $finish;
//    end
//
//    parameter period = 10;
//    parameter half = period / 2;
//
//    initial begin
//        $vcdpluson;
//        i = 0; j = 0;
//        trst_n_i = 0;
//        chip_reset = 1;
//        init = 1;
//        tck_i = 1; #half;
//        tck_i = 0; #half;
//        tck_i = 1; #half;
//        tck_i = 0; #half;
//        tck_i = 1; #half;
//        tck_i = 0; #half;
//        tck_i = 1; #half;
//        trst_n_i = 1;
//        chip_reset = 0;
//        init = 0;
//        tck_i = 0;
//        system_1_in = 2'b01;
//        system_2_in = 2'b10;
//        repeat (1000) #half tck_i = ~tck_i;
//        $display("time out!!!!!!!!!!!!!");
//        $display("time out!!!!!!!!!!!!!");
//        $display("time out!!!!!!!!!!!!!");
//        $display("time out!!!!!!!!!!!!!");
//        $display("time out!!!!!!!!!!!!!");
//        $finish;
//    end
//endmodule