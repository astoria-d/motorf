# Constrains for base clock
create_clock -name 16MHz-CLK -add -period 62.5 -waveform {0 3.125} [get_ports clk16m]

# PLL clock.
create_generated_clock -name 80MHz-CLK -source [get_ports {clk16m}] -master_clock 16MHz-CLK \
	-multiply_by 5 [get_nets {PLL_inst|altpll_component|auto_generated|wire_pll1_clk[0]}]
