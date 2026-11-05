# Project-wide settings: the one place to change the part, board or tool
# versions. Included by the Makefile; values are passed to the scripts.
# (Keep comments on their own lines: Make would keep trailing spaces.)

PROJECT      := fim2

# Kria K26 commercial SOM
PART         := xck26-sfvc784-2LV-c
BOARD_PART   := xilinx.com:k26c:part0:2.0

# Vivado, SDTGen and gen-machine-conf must all match this release.
TOOL_VERSION := 2026.1
EDF_RELEASE  := amd-edf-rel-v26.06.1

# Yocto machine generated from the SDT by gen-machine-conf
MACHINE      ?= zynqmp-fim2-sdt
