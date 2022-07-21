transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

#vlog -vlog01compat -work work +incdir+../../db {../../pll_altpll.v}
vcom -93 -work work {../../uart.vhd}
vcom -93 -work work {../../pll.vhd}
vcom -93 -work work {../../prfx1_test06_uart.vhd}
vcom -93 -work work {./prfx1_test06_uart_testbench.vhd}

vsim work.prfx1_test06_uart_testbench

add wave -label clk16m sim:/prfx1_test06_uart_testbench/sim_board/clk16m
add wave -label clk80m sim:/prfx1_test06_uart_testbench/sim_board/clk80m

add wave -divider baseband_data
add wave -label clk_cnt -radix unsigned sim:/prfx1_test06_uart_testbench/sim_board/demodulator_dummy_inst/clk_cnt
add wave -label data_cnt -radix unsigned sim:/prfx1_test06_uart_testbench/sim_board/demodulator_dummy_inst/data_cnt
add wave -label out_en  sim:/prfx1_test06_uart_testbench/sim_board/demodulator_dummy_inst/out_en
add wave -label out_word -radix hex  sim:/prfx1_test06_uart_testbench/sim_board/demodulator_dummy_inst/out_word


add wave -divider uart
add wave -label cur_state  sim:/prfx1_test06_uart_testbench/sim_board/uart_out_inst/cur_state
add wave -label cur_escape  sim:/prfx1_test06_uart_testbench/sim_board/uart_out_inst/cur_escape
add wave -label reg_uart_data  -radix hex  sim:/prfx1_test06_uart_testbench/sim_board/uart_out_inst/reg_uart_data
add wave -label uart_txd  sim:/prfx1_test06_uart_testbench/sim_board/uart_out_inst/uart_txd


run 100us

wave zoom full

run 300us

