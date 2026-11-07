# HDL sources

Original third-party VHDL is kept as supplied, including comments,
commented-out statements, tabs, spacing and blank lines. Do not fix,
reformat or rename entities in these source files. Integration changes
belong in separate wrappers, project configuration or build scripts.

## Imported sources

- `fim2/FIM2.vhd`
- `fim2/FIM2_slave_lite_v3_5_S00_AXI.vhd`
- `shift_reg_ctrl/shift_reg_ctrl.vhd`
- `carriers/fim2/hdl/FIM2_HWInterface.vhd` (FIM2 carrier pin interface)
- `carriers/fim2/hdl/ALBA_carrier_wrapper.vhd` (earlier, unfinished FIM2 top)
- `carriers/fim2/hdl/kria_starter_kit_wrapper.vhd` (FIM2 top used in the original
  Vivado project: hand-edited block design wrapper with the `som240_*` pin mapping)
- `carriers/fim2/xdc/fim2.xdc` (FIM2 pin constraints, based on the K26 SOM Rev 1 XDC;
  not yet added to the Vivado project)

These files were recovered directly from the original code pasted into
this conversation and checked byte-for-byte against that text. For the
first message, only the prose preceding `library ieee;` was excluded.

## Project integration

Reusable sources live in `hdl/<module>/`. `make xsa` adds `.vhd`, `.vhdl`,
`.v` and `.sv` files from those directories before recreating a carrier's
block design. Optional `carriers/<carrier>/hdl/` sources are specific to
that carrier. Set `HDL_SOURCES` in `carrier.mk` to select an explicit list.

The files remain references to the originals in git. Loading sources does
not by itself instantiate them; a block design does that.

The FIM2 block design, `carriers/fim2/bd/fim2_bd.tcl`, is the original
`kria_starter_kit` design rebuilt in Vivado 2026.1 on the repo's FIM2 PS
settings, with `M_AXI_HPM0_FPD` (128-bit) enabled. It instantiates
`FIM2_HWInterface` and `FIM2` (`C_INPUTS` = 20) as module references, in
place of the original packaged `user.org:user:FIM2:3.5` IP, plus the
original SmartConnect, 8 KB AXI BRAM and processor reset. Addresses: `FIM2_0`
at 0xA001_0000 (64 KB), BRAM at 0xA000_0000 (8 KB). It is named `fim2_bd`
(`BD_NAME` in `carrier.mk`) because VHDL names are case-insensitive: a
design named `fim2` would generate an entity clashing with `FIM2`.

`make xsa` still uses the generated `fim2_bd_wrapper` as top and does not
load `fim2.xdc` or run synthesis. The hand-written `som240_*` top level, the
constraints and the bitstream are still to do. The KR260 block design is
unchanged and PS-only.

Earlier tests of the rewritten FIM2 implementation do not validate these
unchanged originals.

Known problems in the carrier sources, left as supplied:

- `ALBA_carrier_wrapper.vhd` does not parse: the port list has no closing
  `);`, and `kria_starter_kit` has no ports and is not the `fim2` block design.
- `FIM2_HWInterface.vhd` analyzes but will not synthesize:
  `SHR_data_out(16 downto 34)` and `(35 downto 40)` are null ranges
  (`to` was meant), and bits 44 to 47 are never driven.
- `HPA_p(4)`/`HPA_n(4)` feed both RFDet3 and Timming, so two IBUFDS share a pin.
- The `FIM_i` and `FIM_RST_ALRM` outputs are never driven, and the `FIM_o` input
  is unused; `FIM_o_i` comes from inputs 16 downto 11 instead. In the block
  design those ports are what connect it to `FIM2_0`, so the AXI core is not
  in the signal path.
- The block design drives `reset` from `peripheral_aresetn` (active low), but
  `shift_reg_ctrl` resets on `rst = '1'`, so the shift register is held in
  reset while the system runs.
- `fim2.xdc` has no `create_clock`. 18 wrapper ports sit on bank 224 GT pins,
  which cannot be used as plain I/O, and 94 wrapper ports in banks 44, 64 and 65
  have no `IOSTANDARD`. Its `"No Connect"`/`RSV_FPGA_*` lines match no ports.
- `kria_starter_kit_wrapper.vhd` writes every pin as `som240_x <= signal`,
  including the 20 inputs (14 LVDS pairs and 6 single-ended), so no input
  except the 25 MHz clock reaches the logic. It declares all 203 `som240_*`
  ports but uses 72, leaving the bank 224 GT pins and `HPB(10)` (bank 44, no
  `IOSTANDARD`) as top-level ports.
