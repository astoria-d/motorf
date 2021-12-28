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


add wave -label indata -radix decimal  -analog -min -2147483648 -max 2147483648 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/indata
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
add wave -label rom_c -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_c
#add wave -label rom_c -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/rom_c

add wave -label multi_c -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/multi_c
add wave -label multi_c -radix hex sim:/testbench_prfx1_test01/sim_board/demod_inst/multi_c
add wave -label multi_c -radix hex {sim:/testbench_prfx1_test01/sim_board/demod_inst/multi_c[31:5]}
add wave -label multi_c -radix decimal {sim:/testbench_prfx1_test01/sim_board/demod_inst/multi_c[31:5]}

#add wave -label wdata_c0 -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c0
#add wave -label wdata_c0 -radix decimal  -analog -min -80000 -max 80000 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c0
#add wave -label wdata_c15 -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c15
#add wave -label wdata_c15 -radix decimal  -analog -min -80000 -max 80000 -height 100 sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c15
#

add wave -divider constelation

add wave -label base_s -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/base_s
add wave -label base_c -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/base_c
add wave -label result_s -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/result_s
add wave -label result_c -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/result_c

add wave -label base_s -radix hex  {sim:/testbench_prfx1_test01/sim_board/demod_inst/base_s[31:16]}
add wave -label base_c -radix hex  {sim:/testbench_prfx1_test01/sim_board/demod_inst/base_c[31:16]}
add wave -label result_s -radix hex  {sim:/testbench_prfx1_test01/sim_board/demod_inst/result_s[31:16]}
add wave -label result_c -radix hex  {sim:/testbench_prfx1_test01/sim_board/demod_inst/result_c[31:16]}

add wave -label base_s -radix decimal  {sim:/testbench_prfx1_test01/sim_board/demod_inst/base_s[31:16]}
add wave -label base_c -radix decimal  {sim:/testbench_prfx1_test01/sim_board/demod_inst/base_c[31:16]}
add wave -label result_s -radix decimal  {sim:/testbench_prfx1_test01/sim_board/demod_inst/result_s[31:16]}
add wave -label result_c -radix decimal  {sim:/testbench_prfx1_test01/sim_board/demod_inst/result_c[31:16]}

add wave -label dmulti0 -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/dmulti0
add wave -label dmulti1 -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/dmulti1
add wave -label dmulti2 -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/dmulti2
add wave -label dmulti3 -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/dmulti3

add wave -label conste_i -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/conste_i
add wave -label conste_q -radix decimal  sim:/testbench_prfx1_test01/sim_board/demod_inst/conste_q

add wave -label out_word -radix hex  sim:/testbench_prfx1_test01/sim_board/demod_inst/out_word
add wave -label out_en sim:/testbench_prfx1_test01/sim_board/demod_inst/out_en


add wave -divider wdata_c

add wave -label wdata_c0 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c0
add wave -label wdata_c1 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c1
add wave -label wdata_c2 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c2
add wave -label wdata_c3 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c3
add wave -label wdata_c4 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c4
add wave -label wdata_c5 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c5
add wave -label wdata_c6 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c6
add wave -label wdata_c7 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c7
add wave -label wdata_c8 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c8
add wave -label wdata_c9 -radix decimal  -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c9
add wave -label wdata_c10 -radix decimal -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c10
add wave -label wdata_c11 -radix decimal -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c11
add wave -label wdata_c12 -radix decimal -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c12
add wave -label wdata_c13 -radix decimal -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c13
add wave -label wdata_c14 -radix decimal -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c14
add wave -label wdata_c15 -radix decimal -analog -min -1000000000 -max 1000000000 -height 100  sim:/testbench_prfx1_test01/sim_board/demod_inst/wdata_c15

run 15us

wave zoom full

run 80us
run 70us

wave zoom full

#run 10us
#run 10us
#run 10us
#run 10us
#run 10us
#run 10us
#run 10us

