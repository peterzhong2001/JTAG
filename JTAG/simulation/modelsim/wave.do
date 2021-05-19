onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /jtag_top_tb/tck_i
add wave -noupdate /jtag_top_tb/trst_n_i
add wave -noupdate /jtag_top_tb/tms_i
add wave -noupdate /jtag_top_tb/tdi_i
add wave -noupdate /jtag_top_tb/tdo_o
add wave -noupdate /jtag_top_tb/jtag/clock_ir
add wave -noupdate /jtag_top_tb/jtag/shift_ir
add wave -noupdate /jtag_top_tb/jtag/update_ir
add wave -noupdate /jtag_top_tb/jtag/instr
add wave -noupdate /jtag_top_tb/jtag/clock_dr
add wave -noupdate /jtag_top_tb/jtag/shift_dr
add wave -noupdate /jtag_top_tb/jtag/update_dr
add wave -noupdate -radix hexadecimal /jtag_top_tb/tap_states
add wave -noupdate /jtag_top_tb/jtag/scan_reg_out
add wave -noupdate /jtag_top_tb/jtag/instr_reg_out
add wave -noupdate /jtag_top_tb/jtag/update_dr
add wave -noupdate /jtag_top_tb/jtag/toChip_two
add wave -noupdate /jtag_top_tb/jtag/fromChip_two
add wave -noupdate /jtag_top_tb/jtag/mode
add wave -noupdate /jtag_top_tb/jtag/bsr_decoder_out
add wave -noupdate /jtag_top_tb/jtag/pIN_1
add wave -noupdate /jtag_top_tb/jtag/pOUT_1
add wave -noupdate /jtag_top_tb/jtag/pIN_2
add wave -noupdate /jtag_top_tb/jtag/mode
add wave -noupdate /jtag_top_tb/jtag/pOUT_2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {831 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 132
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1376 ps}
