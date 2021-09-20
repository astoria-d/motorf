transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+E:/daisuke/rf/repo/motorf/prfx1_test03_tx/db {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/db/pll_altpll.v}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/prfx1_test03_tx.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/PLL.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/DDR_OUT.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/tx_data.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/utils.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/wave_mem.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/tx_baseband.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/lpf.vhd}
#vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/upconv.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/spi_init.vhd}
vcom -93 -work work {E:/daisuke/rf/repo/motorf/prfx1_test03_tx/simulation/modelsim/prfx1_test03_tx_test01.vhd}

vsim -gui -l msim_transcript work.prfx1_test03_tx_test01

add wave -label clk16m 		sim:/prfx1_test03_tx_test01/sim_board/clk16m
add wave -label dac_clk 	sim:/prfx1_test03_tx_test01/sim_board/dac_clk
add wave -label spiclk 		sim:/prfx1_test03_tx_test01/sim_board/spiclk
add wave -label sdi 		sim:/prfx1_test03_tx_test01/sim_board/sdi
add wave -label spics_dac 	sim:/prfx1_test03_tx_test01/sim_board/spics_dac
add wave -label spics_pll 	sim:/prfx1_test03_tx_test01/sim_board/spics_pll


add wave -divider dac_spi_init_data_inst
add wave -label clk16m 					sim:/prfx1_test03_tx_test01/sim_board/dac_spi_init_data_inst/clk16m
add wave -label oe_n 					sim:/prfx1_test03_tx_test01/sim_board/dac_spi_init_data_inst/oe_n
add wave -label reset_n 				sim:/prfx1_test03_tx_test01/sim_board/dac_spi_init_data_inst/reset_n
add wave -label indata 		-radix hex	sim:/prfx1_test03_tx_test01/sim_board/dac_spi_init_data_inst/indata
add wave -label trig 					sim:/prfx1_test03_tx_test01/sim_board/dac_spi_init_data_inst/trig

add wave -divider dac_spi_out_inst
add wave -label clk16m 					sim:/prfx1_test03_tx_test01/sim_board/dac_spi_out_inst/clk16m
add wave -label indata 		-radix hex	sim:/prfx1_test03_tx_test01/sim_board/dac_spi_out_inst/indata
add wave -label trig 					sim:/prfx1_test03_tx_test01/sim_board/dac_spi_out_inst/trig
add wave -label spics 					sim:/prfx1_test03_tx_test01/sim_board/dac_spi_out_inst/spics
add wave -label sdi 					sim:/prfx1_test03_tx_test01/sim_board/dac_spi_out_inst/sdi

add wave -divider pll_spi_init_data_inst
add wave -label clk16m 					sim:/prfx1_test03_tx_test01/sim_board/pll_spi_init_data_inst/clk16m
add wave -label oe_n 					sim:/prfx1_test03_tx_test01/sim_board/pll_spi_init_data_inst/oe_n
add wave -label reset_n 				sim:/prfx1_test03_tx_test01/sim_board/pll_spi_init_data_inst/reset_n
add wave -label indata 		-radix hex	sim:/prfx1_test03_tx_test01/sim_board/pll_spi_init_data_inst/indata
add wave -label trig 					sim:/prfx1_test03_tx_test01/sim_board/pll_spi_init_data_inst/trig

add wave -divider pll_spi_out_inst
add wave -label clk16m 					sim:/prfx1_test03_tx_test01/sim_board/pll_spi_out_inst/clk16m
add wave -label indata 		-radix hex	sim:/prfx1_test03_tx_test01/sim_board/pll_spi_out_inst/indata
add wave -label trig 					sim:/prfx1_test03_tx_test01/sim_board/pll_spi_out_inst/trig
add wave -label spics 					sim:/prfx1_test03_tx_test01/sim_board/pll_spi_out_inst/spics
add wave -label sdi 					sim:/prfx1_test03_tx_test01/sim_board/pll_spi_out_inst/sdi

run 50us
wave zoom full

