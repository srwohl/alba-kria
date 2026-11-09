# FIM2 loads its bitstream from BOOT.BIN, so the PL runs before Linux:
# gen-machine-conf sets BITSTREAM_PATH from the .bit that make sdt copies into
# the SDT. The KR260 design is PS-only and has no bitstream; without the
# fpga-overlay MACHINE_FEATURE the recipe would still add a bitstream
# partition and depend on one.
BIF_BITSTREAM_ATTR:k26-kr260-sdt = ""
