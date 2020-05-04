transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/daisuke/rf/repo/motorf/prfx1_test01 {E:/daisuke/rf/repo/motorf/prfx1_test01/MY_NCO.v}
vlog -vlog01compat -work work +incdir+E:/daisuke/rf/repo/motorf/prfx1_test01/db {E:/daisuke/rf/repo/motorf/prfx1_test01/db/pll_altpll.v}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/prfx1_test01.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/ad9117_spi_init.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/DDR_OUT.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/PLL.vhd}

vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/testbench_prfx1_test01.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  testbench_prfx1_test01

add wave -divider input
add wave -label clk16m                  sim:/testbench_prfx1_test01/sim_board/clk16m;
add wave -label rst_n                   sim:/testbench_prfx1_test01/sim_board/sw2;

add wave -divider dac
add wave -label dac_clk     -radix hex  sim:/testbench_prfx1_test01/sim_board/dac_clk;
add wave -label dac                     sim:/testbench_prfx1_test01/sim_board/dac;

add wave -divider spi
add wave -label spiclk                  sim:/testbench_prfx1_test01/sim_board/spiclk;
add wave -label spics                   sim:/testbench_prfx1_test01/sim_board/spics;
add wave -label sdi                     sim:/testbench_prfx1_test01/sim_board/sdi;


view structure
view signals
run 15 us
wave zoom full
