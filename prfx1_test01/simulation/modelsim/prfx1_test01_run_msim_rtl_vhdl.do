transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/prfx1_test01.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/tx_baseband.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/wave_mem.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/tx_data.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/upconv.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/moto_nco.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/spi_init.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/DDR_OUT.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/PLL.vhd}


#vlog -vlog01compat -work work +incdir+E:/daisuke/rf/repo/motorf/prfx1_test01 {E:/daisuke/rf/repo/motorf/prfx1_test01/MY_NCO.v}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/cordic/CORDIC_CORE.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/cordic/CORDIC_PRE.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/cordic/CORDIC_POST.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/cordic/CORDIC.vhd}


vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test01/testbench_prfx1_test01.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  testbench_prfx1_test01

add wave -divider input
add wave -label clk16m                  sim:/testbench_prfx1_test01/sim_board/clk16m;
add wave -label sw1                     sim:/testbench_prfx1_test01/sim_board/sw1;
add wave -label sw2                     sim:/testbench_prfx1_test01/sim_board/sw2;
add wave -label reset_n                 sim:/testbench_prfx1_test01/sim_board/reset_n;

add wave -divider tx_data
add wave -label tx_data_sym     -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_data_sym;

add wave -divider baseband
add wave -label count_76us       -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/count_76us;
add wave -label count_100sym     -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/count_100sym;

add wave -label bb_i -analog -min -65565 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_i;

add wave -label tmp_i -analog -min -250000 -max 250000 -height 200  -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/tmp_i;

add wave -label address  -radix unsigned  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/address;

add wave -label bb_data_cos0 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos0;
add wave -label bb_data_cos1 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos1;
add wave -label bb_data_cos2 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos2;
add wave -label bb_data_cos3 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos3;
add wave -label bb_data_cos4 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos4;
add wave -label bb_data_cos5 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos5;
add wave -label bb_data_cos6 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos6;
add wave -label bb_data_cos7 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos7;
add wave -label bb_data_cos8 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos8;
add wave -label bb_data_cos9 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos9;
add wave -label bb_data_cos10 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos10;
add wave -label bb_data_cos11 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos11;
add wave -label bb_data_cos12 -analog -min 0 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos12;
add wave -label bb_data_cos13 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos13;
add wave -label bb_data_cos14 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos14;
add wave -label bb_data_cos15 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos15;
add wave -label bb_data_cos_cw -analog -min 0 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_cos_cw;

#add wave -label bb_q -analog -min -65565 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/bb_q;
#
#add wave -label tmp_q -analog -min -65565 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/tmp_q;
#
#add wave -label bb_data_sin0 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin0;
#add wave -label bb_data_sin1 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin1;
#add wave -label bb_data_sin2 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin2;
#add wave -label bb_data_sin3 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin3;
#add wave -label bb_data_sin4 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin4;
#add wave -label bb_data_sin5 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin5;
#add wave -label bb_data_sin6 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin6;
#add wave -label bb_data_sin7 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin7;
#add wave -label bb_data_sin8 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin8;
#add wave -label bb_data_sin9 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin9;
#add wave -label bb_data_sin10 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin10;
#add wave -label bb_data_sin11 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin11;
#add wave -label bb_data_sin12 -analog -min 0 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin12;
#add wave -label bb_data_sin13 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin13;
#add wave -label bb_data_sin14 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin14;
#add wave -label bb_data_sin15 -analog -min 0 -max 65565 -height 40   -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin15;
#add wave -label bb_data_sin_cw -analog -min 0 -max 65565 -height 40  -radix decimal  sim:/testbench_prfx1_test01/sim_board/tx_baseband_inst/bb_data_sin_cw;
#

add wave -divider upconv_1mhz

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

#add wave -label sin -analog -min -32768 -max 32768 -height 40 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/sin;
#add wave -label cos -analog -min -32768 -max 32768 -height 40 -radix decimal sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/cos;


#add wave -divider dac_spi_data
#add wave -label reset_n                 sim:/testbench_prfx1_test01/sim_board/dac_spi_init_data_inst/reset_n;
#add wave -label clk16m                  sim:/testbench_prfx1_test01/sim_board/dac_spi_init_data_inst/clk16m;
#add wave -label indata     -radix hex   sim:/testbench_prfx1_test01/sim_board/dac_spi_init_data_inst/indata;
#add wave -label trig                    sim:/testbench_prfx1_test01/sim_board/dac_spi_init_data_inst/trig;
#
#add wave -divider pll_spi_data
#add wave -label reset_n                 sim:/testbench_prfx1_test01/sim_board/pll_spi_init_data_inst/reset_n;
#add wave -label clk16m                  sim:/testbench_prfx1_test01/sim_board/pll_spi_init_data_inst/clk16m;
#add wave -label indata     -radix hex   sim:/testbench_prfx1_test01/sim_board/pll_spi_init_data_inst/indata;
#add wave -label trig                    sim:/testbench_prfx1_test01/sim_board/pll_spi_init_data_inst/trig;
#
#add wave -divider spi
#add wave -label spics_dac       sim:/testbench_prfx1_test01/sim_board/spics_dac;
#add wave -label spics_pll       sim:/testbench_prfx1_test01/sim_board/spics_pll;
#add wave -label spiclk          sim:/testbench_prfx1_test01/sim_board/spiclk;
#add wave -label sdi             sim:/testbench_prfx1_test01/sim_board/sdi;

#add wave -divider dac
#add wave -label dac_clk     -radix hex  sim:/testbench_prfx1_test01/sim_board/dac_clk;
#add wave -label dac   -analog -min -7000 -max 7000 -height 300 -radix decimal sim:/testbench_prfx1_test01/sim_board/dac;
#

#add wave -divider codic
#
##add wave -label x0                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x0
##add wave -label x1                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x1
##add wave -label x2                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x2
##add wave -label x3                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x3
##add wave -label x4                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x4
##add wave -label x5                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x5
##add wave -label x6                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x6
##add wave -label x7                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x7
##add wave -label x8                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x8
##add wave -label x9                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x9
##add wave -label x10                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x10
##add wave -label x11                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x11
##add wave -label x12                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x12
##add wave -label x13                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x13
##add wave -label x14                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x14
##add wave -label x15                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x15
##add wave -label x16                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x16
##add wave -label x17                              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/x17
##
##add wave -label sin    -analog -min 0 -max 5 -height 100              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/sin;
##add wave -label cos    -analog -min 0 -max 5 -height 100              sim:/testbench_prfx1_test01/sim_board/NCO_1MHz/cos;
#
#
#add wave -label theta    -analog -min 0 -max 524287   -height 100  -radix unsigned sim:/testbench_prfx1_test01/theta;
#add wave -label sin      -analog -min -1000 -max 1000 -height 100  -radix decimal sim:/testbench_prfx1_test01/sin;



view structure
view signals
#run 50 us
run 78 us
wave zoom full
run 155 us
