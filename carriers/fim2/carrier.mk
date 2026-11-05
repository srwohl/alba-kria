# FIM2 MainBoard carrier (PandA) with a production K26C SOM.
# One carrier directory is one SOM + carrier combination; bd/fim2.tcl is
# its block design, as written by Vivado's write_bd_tcl.

PART       := xck26-sfvc784-2LV-c
BOARD_PART := xilinx.com:k26c:part0:2.0

# Production SOMs carry eMMC; the KV260/KR260 starter-kit SOMs do not.
HAS_EMMC   := 1

# User device tree, merged in this order by scripts/generate_sdt.sh
DTSI       := som/k26/dts/k26-som.dtsi som/k26/dts/k26-emmc.dtsi carriers/fim2/dts/carrier.dtsi

# Yocto machine generated from this carrier's SDT by gen-machine-conf
MACHINE    ?= zynqmp-fim2-sdt
