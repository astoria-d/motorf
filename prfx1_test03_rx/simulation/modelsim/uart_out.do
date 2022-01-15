transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/simulation/modelsim/uart_test_banch.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/prfx1_test03_rx.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/pll.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/uart.vhd}

vsim work.uart_test_banch

add wave -label clk80m sim:/uart_test_banch/sim_board/clk80m
add wave -label reset_n sim:/uart_test_banch/sim_board/reset_n

add wave -label symbol_num -radix decimal  sim:/uart_test_banch/sim_board/symbol_num
add wave -label symbol_cnt -radix decimal  sim:/uart_test_banch/sim_board/symbol_cnt
add wave -label demod_out -radix hex sim:/uart_test_banch/sim_board/demod_out

add wave -divider wdata_c

add wave -label uart_data -radix hex  sim:/uart_test_banch/sim_board/uart_out_inst/uart_data


run 200us

wave zoom full

#run 300us

