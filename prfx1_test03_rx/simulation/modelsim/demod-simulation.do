transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

##vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/simulation/modelsim/debug_stub.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/simulation/modelsim/demod-test_banch.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/prfx1_test03_rx.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/pll.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/utils.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/wave_mem.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/demodulator.vhd}

vsim work.testbench_prfx1_test01

add wave -label clk16m sim:/testbench_prfx1_test01/sim_board/clk16m
add wave -label clk80m sim:/testbench_prfx1_test01/sim_board/clk80m
add wave -label reset_n sim:/testbench_prfx1_test01/sim_board/reset_n

add wave -label symbol_num -radix decimal  sim:/testbench_prfx1_test01/sim_board/symbol_num
add wave -label symbol_cnt -radix decimal  sim:/testbench_prfx1_test01/sim_board/symbol_cnt

add wave -label in_rom_addr -radix decimal  sim:/testbench_prfx1_test01/sim_board/debut_inst/in_rom_addr
add wave -label input_data -radix decimal  -analog -min -80000 -max 80000 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/indata

run 30us

wave zoom full

