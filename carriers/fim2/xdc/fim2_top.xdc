# Pin constraints for fim2_top, added layer by layer during bring-up. Pins,
# standards and drive come from the original constraints in fim2.xdc, which
# is kept as supplied and not loaded.

# Bank 44 is powered by the carrier (som240_2_d59). LVCMOS18 as in fim2.xdc;
# check against the FIM2 schematic that bank 44 runs at 1.8 V.

# hw_clk_25MHz, IO_L8P_HDGC_44 (clock-capable)
set_property PACKAGE_PIN AB15 [get_ports som240_2_b57]
set_property IOSTANDARD LVCMOS18 [get_ports som240_2_b57]
create_clock -period 40.000 -name hw_clk_25MHz [get_ports som240_2_b57]

# LED1, IO_L8N_HDGC_44
set_property PACKAGE_PIN AB14 [get_ports som240_2_b58]
set_property IOSTANDARD LVCMOS18 [get_ports som240_2_b58]
set_property SLEW SLOW [get_ports som240_2_b58]
set_property DRIVE 4 [get_ports som240_2_b58]
