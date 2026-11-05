# The block designs are PS-only for now: there is no bitstream to put in
# BOOT.BIN. Without the fpga-overlay MACHINE_FEATURE the recipe would add a
# bitstream partition and depend on one. Remove this once the PL has a design.
BIF_BITSTREAM_ATTR = ""
