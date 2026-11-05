# AMD KR260 carrier with a production K26C SOM, built through the same
# flow as FIM2: our own block design, machine and
# BOOT.BIN. AMD's KR260 board files and kit images are not used.
# bd/kr260.tcl is FIM2's block design with the KR260's PS peripherals.

PART       := xck26-sfvc784-2LV-c
BOARD_PART := xilinx.com:k26c:part0:2.0

# Production K26C: eMMC fitted (the kit SOM that ships with the KR260 has none).
HAS_EMMC   := 1

# User device tree, merged in this order by scripts/generate_sdt.sh
DTSI       := som/k26/dts/k26-som.dtsi som/k26/dts/k26-emmc.dtsi carriers/kr260/dts/carrier.dtsi

# Yocto machine generated from this carrier's SDT by gen-machine-conf
MACHINE    ?= zynqmp-kr260-sdt
