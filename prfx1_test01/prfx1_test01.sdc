# Constrains for base clock
create_clock -name 16MHz-CLK -add -period 62.5 -waveform {0 3.125} [get_ports clk16m]

# PLL clock.
create_generated_clock -name 80MHz-CLK -add -source [get_pins PLL:PLL_inst|altpll:altpll_component|PLL_altpll:auto_generated|wire_pll1_inclk[0]] \
			-multiply_by 5 -master_clock 16MHz-CLK [get_pins PLL:PLL_inst|altpll:altpll_component|PLL_altpll:auto_generated|wire_pll1_clk[0]]

#derive_pll_clocks -create_base_clocks

#create_clock -name 80MHz-CLK -period 12.5 -waveform {0 6.25}  [get_nets {inst1|altpll_component|auto_generated|wire_pll1_clk[0]}]
#create_generated_clock -name 80MHz-CLK -add -source  [get_ports clk16m]  -multiply_by 5 -master_clock 16MHz-CLK [get_pins PLL_inst|c0]
#create_generated_clock \
#	-name 80MHz-CLK \
#	-source [get_pins {PLL_inst|altpll_component|pll|inclk[0]}] \
#	[get_pins {PLL_inst|altpll_component|pll|clk[0]}]


# ベース・クロックに対して制約を与えます
##create_clock -add -period 10.000 \
#-waveform { 0.000 5.000 } \
#-name clock_name \
#[get_ports clock]

# 出力クロックに対して制約を与えます
#create_generated_clock -add -source PLL_inst|inclk[0] \
#-name PLL_inst|clk[1] \
#-multiply_by 2 \
#-master_clock clock_name \
#[get_pins PLL_inst|clk[1]]

#create_clock -period 10.000 -name clk [get_ports {clk}]
#create_generated_clock \
#	-name PLL_C0 \
#	-source [get_pins {PLL|altpll_component|pll|inclk[0]}] \
#	[get_pins {PLL|altpll_component|pll|clk[0]}]
#create_generated_clock \
#	-name PLL_C1 \
#	-multiply_by 2 \
#	-source [get_pins {PLL|altpll_component|pll|inclk[0]}] \
#	[get_pins {PLL|altpll_component|pll|clk[1]}]
