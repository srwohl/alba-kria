# FIM2 MainBoard carrier (PandA) with a production K26C SOM.
# One carrier directory is one SOM + carrier combination; bd/fim2_bd.tcl is
# its block design, as written by Vivado's write_bd_tcl.

SOM        := k26
PART       := xck26-sfvc784-2LV-c
BOARD_PART := xilinx.com:k26c:part0:2.0

# Production SOMs carry eMMC; the KV260/KR260 starter-kit SOMs do not.
HAS_EMMC   := 1

# Not "fim2": VHDL names are case-insensitive, so the block design's
# generated top would clash with the FIM2 entity in hdl/fim2/FIM2.vhd.
BD_NAME    := fim2_bd

# User device tree, merged in this order by scripts/generate_sdt.sh
DTSI       := som/$(SOM)/dts/k26-som.dtsi som/$(SOM)/dts/k26-emmc.dtsi carriers/fim2/dts/carrier.dtsi

# PL top level and constraints, built up during bring-up (hdl/README.md).
# Layer 3: FIM2_HWInterface behind the PS-to-PL AXI bus and 8 KB BRAM.
TOP         := fim2_top
HDL_SOURCES := carriers/fim2/hdl/fim2_top.vhd carriers/fim2/hdl/FIM2_HWInterface.vhd \
               hdl/shift_reg_ctrl/shift_reg_ctrl.vhd
XDC_SOURCES := carriers/fim2/xdc/fim2_top.xdc
