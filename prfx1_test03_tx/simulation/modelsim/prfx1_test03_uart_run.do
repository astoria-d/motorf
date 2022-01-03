transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {../../prfx1_test03_tx.vhd}
vcom -93 -work work {../../PLL.vhd}
vcom -93 -work work {../../uart.vhd}
vcom -93 -work work {../../tx_data.vhd}
vcom -93 -work work {../../simulation/modelsim/prfx1_test03_uart_test01.vhd}

vsim -gui -l msim_transcript work.prfx1_test03_uart_test01

--add wave -label clk16m 		sim:/prfx1_test03_uart_test01/sim_board/clk16m

#add wave -label symbol_cnt -radix unsigned sim:/prfx1_test03_uart_test01/sim_board/symbol_cnt
add wave -label symbol_num -radix unsigned sim:/prfx1_test03_uart_test01/sim_board/symbol_num


add wave -label uart_rxd sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/uart_inst/uart_rxd
add wave -label cur_state sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/uart_inst/cur_state
add wave -label reg_uart_data -radix hex sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/uart_inst/reg_uart_data

add wave -label uart_data_latch -radix hex  sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/uart_data_latch

add wave -label outdata_0 -radix hex  sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/outdata_0
add wave -label outdata_1 -radix hex  sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/outdata_1
add wave -label outdata_2 -radix hex  sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/outdata_2
add wave -label outdata_3 -radix hex  sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/outdata_3

add wave -label outdata_reg -radix hex sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/outdata_reg
add wave -label tx_data -radix hex sim:/prfx1_test03_uart_test01/sim_board/data_gen_inst/tx_data


run 150us
wave zoom full
run 8ms

