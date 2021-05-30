transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/daisuke/rf/repo/motorf/prfx1_test03_rx/db {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/db/pll_altpll.v}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/prfx1_test03_rx.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/pll.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/spi_init.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_rx/simulation/modelsim/prfx1_test03_rx_testbench.vhd}

vsim work.testbench_prfx1_test01

add wave -label clk16m sim:/testbench_prfx1_test01/sim_board/clk16m
add wave -label reset_n sim:/testbench_prfx1_test01/sim_board/reset_n

add wave -label spiclk sim:/testbench_prfx1_test01/sim_board/spiclk
add wave -label sdi -radix hex sim:/testbench_prfx1_test01/sim_board/sdi
add wave -label spics_pll sim:/testbench_prfx1_test01/sim_board/spics_pll

run 60us

wave zoom full

