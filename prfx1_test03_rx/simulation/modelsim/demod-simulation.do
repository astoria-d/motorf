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
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/multi_0.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/utils.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/wave_mem.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/demodulator.vhd}

vsim work.testbench_prfx1_test01

add wave -label clk16m sim:/testbench_prfx1_test01/sim_board/clk16m
add wave -label clk80m sim:/testbench_prfx1_test01/sim_board/clk80m
add wave -label reset_n sim:/testbench_prfx1_test01/sim_board/reset_n

add wave -label symbol_num -radix decimal  sim:/testbench_prfx1_test01/sim_board/symbol_num
add wave -label symbol_cnt -radix decimal  sim:/testbench_prfx1_test01/sim_board/symbol_cnt

#add wave -label in_rom_addr -radix decimal  sim:/testbench_prfx1_test01/sim_board/debut_inst/in_rom_addr
#add wave -label input_data -radix decimal  -analog -min -80000 -max 80000 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/indata


add wave -label indata -radix decimal  -analog -min -80000 -max 80000 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/indata
add wave -label indata -radix hex sim:/testbench_prfx1_test01/sim_board/demod_inst/indata
add wave -label indata_hi -radix hex {sim:/testbench_prfx1_test01/sim_board/demod_inst/indata[31:16]}
add wave -label indata_hi -radix decimal {sim:/testbench_prfx1_test01/sim_board/demod_inst/indata[31:16]}

add wave -label rom_addr -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_addr

add wave -label rom_cos0 -radix hex sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_cos0
add wave -label rom_cos0 -radix decimal sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_cos0

add wave -label rom_cos15 -radix hex sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_cos15
#add wave -label rom_cos0 -radix decimal  -analog -min -80000 -max 80000 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_cos0
#add wave -label rom_cos15 -radix decimal  -analog -min -80000 -max 80000 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_cos15

add wave -label rom_c -radix hex  sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_c
#add wave -label rom_c -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_c

add wave -label multi_c -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/multi_c

add wave -label wdata_base_c0 -radix decimal  -analog -min -80000 -max 80000 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_base_c0
add wave -label wdata_base_c15 -radix decimal  -analog -min -80000 -max 80000 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_base_c15

add wave -label base_c -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/base_c


run 15us

wave zoom full

#run 10us
#run 10us
#run 10us
#run 10us
#run 10us
#run 10us
#run 10us

