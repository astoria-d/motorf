transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/prfx1_test01.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/spi_init.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/DDR_OUT.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/PLL.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/wave_mem.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/moto_nco.vhd}
vlog -vlog01compat -work work +incdir+E:/daisuke/rf/repo/motorf/prfx1_test01 {E:/daisuke/rf/repo/motorf/prfx1_test01/MY_NCO.v}

vcom -93 -work work {E:/daisuke/rf/repo/motorf/cordic/CORDIC_CORE.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/cordic/CORDIC_PRE.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/cordic/CORDIC_POST.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/cordic/CORDIC.vhd}


vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/testbench_prfx1_test01.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  testbench_prfx1_test01

add wave -divider input
add wave -label clk16m                  sim:/testbench_prfx1_test01/sim_board/clk16m;
add wave -label sw1                     sim:/testbench_prfx1_test01/sim_board/sw1;
add wave -label sw2                     sim:/testbench_prfx1_test01/sim_board/sw2;
add wave -label reset_n                 sim:/testbench_prfx1_test01/sim_board/reset_n;

add wave -divider regs
add wave -label count_76us       -radix decimal  sim:/testbench_prfx1_test01/sim_board/count_76us;
add wave -label count_100sym     -radix decimal  sim:/testbench_prfx1_test01/sim_board/count_100sym;

add wave -divider baseband
add wave -label address  -radix decimal  sim:/testbench_prfx1_test01/sim_board/address;
add wave -label bb_data_sin4 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_data_sin4;
add wave -label bb_data_cos4 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_data_cos4;
add wave -label bb_data_sin8 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_data_sin8;
add wave -label bb_data_cos8 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_data_cos8;
add wave -label bb_data_sin12 -analog -min 0 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_data_sin12;
add wave -label bb_data_cos12 -analog -min 0 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_data_cos12;
add wave -label bb_data_sin16 -analog -min 0 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_data_sin16;
add wave -label bb_data_cos16 -analog -min 0 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_data_cos16;


add wave -divider codic

#add wave -label phase32  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/phase32
#
#add wave -label judge0  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/judge0
#add wave -label phase0  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/phase0
#add wave -label temp0  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/temp0
#add wave -label x0  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x0
#
#
#
#add wave -label x1  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x1
#add wave -label x2  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x2
#add wave -label x3  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x3
#add wave -label x4  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x4
#add wave -label x5  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x5
#add wave -label x6  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x6
#add wave -label x7  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x7
#add wave -label x8  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x8
#add wave -label x9  -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x9
#add wave -label x10 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x10
#add wave -label x11 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x11
#add wave -label x12 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x12
#add wave -label x13 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x13
#add wave -label x14 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x14
#add wave -label x15 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x15
#add wave -label x16 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x16
#add wave -label x17 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x17

add wave -label sin -analog -min 0 -max 65565 -height 40 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/sin;
add wave -label cos -analog -min 0 -max 65565 -height 40 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/cos;


add wave -divider dac_spi_data
add wave -label reset_n                 sim:/testbench_prfx1_test01/sim_board/dac_spi_init_data_inst/reset_n;
add wave -label clk16m                  sim:/testbench_prfx1_test01/sim_board/dac_spi_init_data_inst/clk16m;
add wave -label indata     -radix hex   sim:/testbench_prfx1_test01/sim_board/dac_spi_init_data_inst/indata;
add wave -label trig                    sim:/testbench_prfx1_test01/sim_board/dac_spi_init_data_inst/trig;

add wave -divider pll_spi_data
add wave -label reset_n                 sim:/testbench_prfx1_test01/sim_board/pll_spi_init_data_inst/reset_n;
add wave -label clk16m                  sim:/testbench_prfx1_test01/sim_board/pll_spi_init_data_inst/clk16m;
add wave -label indata     -radix hex   sim:/testbench_prfx1_test01/sim_board/pll_spi_init_data_inst/indata;
add wave -label trig                    sim:/testbench_prfx1_test01/sim_board/pll_spi_init_data_inst/trig;

add wave -divider spi
add wave -label spics_dac       sim:/testbench_prfx1_test01/sim_board/spics_dac;
add wave -label spics_pll       sim:/testbench_prfx1_test01/sim_board/spics_pll;
add wave -label spiclk          sim:/testbench_prfx1_test01/sim_board/spiclk;
add wave -label sdi             sim:/testbench_prfx1_test01/sim_board/sdi;

add wave -divider dac
add wave -label dac_clk     -radix hex  sim:/testbench_prfx1_test01/sim_board/dac_clk;
add wave -label dac   -analog -min 0 -max 65565 -height 100 -radix decimal sim:/testbench_prfx1_test01/sim_board/dac;


add wave -divider codic

#add wave -label x0                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x0
#add wave -label x1                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x1
#add wave -label x2                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x2
#add wave -label x3                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x3
#add wave -label x4                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x4
#add wave -label x5                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x5
#add wave -label x6                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x6
#add wave -label x7                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x7
#add wave -label x8                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x8
#add wave -label x9                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x9
#add wave -label x10                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x10
#add wave -label x11                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x11
#add wave -label x12                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x12
#add wave -label x13                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x13
#add wave -label x14                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x14
#add wave -label x15                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x15
#add wave -label x16                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x16
#add wave -label x17                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x17
#
#add wave -label sin    -analog -min 0 -max 5 -height 100              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/sin;
#add wave -label cos    -analog -min 0 -max 5 -height 100              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/cos;


add wave -label theta    -analog -min 0 -max 524287   -height 100  -radix unsigned sim:/testbench_prfx1_test01/theta;
add wave -label sin      -analog -min -1000 -max 1000 -height 100  -radix decimal sim:/testbench_prfx1_test01/sin;



view structure
view signals
#run 50 us
run 78 us
wave zoom full
