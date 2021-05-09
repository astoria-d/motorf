transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/daisuke/rf/repo/motorf/prfx1_test03_rx/db {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/db/pll_altpll.v}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/prfx1_test03_rx.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/pll.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/simulation/modelsim/prfx1_test03_rx_testbench.vhd}

vsim work.testbench_prfx1_test01

add wave -position insertpoint  sim:/testbench_prfx1_test01/sim_board/clk16m

run 10us

wave zoom full

