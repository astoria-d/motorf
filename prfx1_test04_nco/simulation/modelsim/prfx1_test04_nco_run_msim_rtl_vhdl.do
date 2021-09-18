transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test04_nco/simulation/modelsim/prfx1_test04_nco_test01.vhd}
vlog -vlog01compat -work work +incdir+E:/daisuke/rf/repo/motorf/prfx1_test04_nco/db {E:/daisuke/rf/repo/motorf/prfx1_test04_nco/db/pll_altpll.v}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test04_nco/prfx1_test04_nco.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test04_nco/DDR_OUT.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test04_nco/PLL.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test04_nco/moto_nco.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test04_nco/spi_init.vhd}

vsim -gui -l msim_transcript work.prfx1_test04_nco_test01


add wave sim:/prfx1_test04_nco_test01/sim_board/clk16m
add wave \
sim:/prfx1_test04_nco_test01/sim_board/dac_clk \
sim:/prfx1_test04_nco_test01/sim_board/spiclk \
sim:/prfx1_test04_nco_test01/sim_board/sdi \
sim:/prfx1_test04_nco_test01/sim_board/spics_dac

add wave -position insertpoint sim:/prfx1_test04_nco_test01/sim_board/dac_spi_init_data_inst/*

add wave -position insertpoint sim:/prfx1_test04_nco_test01/sim_board/dac_spi_out_inst/*


run 10us
wave zoom full

