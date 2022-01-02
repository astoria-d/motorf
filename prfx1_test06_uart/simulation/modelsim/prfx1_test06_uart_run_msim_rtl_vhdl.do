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

add wave -label uart_clk_cnt -radix unsigned sim:/prfx1_test06_uart_testbench/sim_board/uart_clk_cnt

add wave -label uart_data_en  sim:/prfx1_test06_uart_testbench/sim_board/uart_data_en
add wave -label uart_data -radix hex  sim:/prfx1_test06_uart_testbench/sim_board/uart_data


add wave -label cur_state  sim:/prfx1_test06_uart_testbench/sim_board/uart_out_inst/cur_state
add wave -label reg_uart_data  -radix hex  sim:/prfx1_test06_uart_testbench/sim_board/uart_out_inst/reg_uart_data
add wave -label uart_txd  sim:/prfx1_test06_uart_testbench/sim_board/uart_out_inst/uart_txd


run 50us

wave zoom full

