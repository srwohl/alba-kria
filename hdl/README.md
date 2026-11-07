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

The FIM2 PL design is being brought up in layers, one commit each:

1. 25 MHz clock and LED1: `carriers/fim2/hdl/fim2_top.vhd` blinks LED1;
   the block design is PS only. Tested on the board.
2. PS-to-PL AXI (current): `M_AXI_HPM0_FPD`, SmartConnect, processor reset
   and the 8 KB BRAM at 0xA000_0000, as in the original design.
3. Outputs: `FIM2_HWInterface`, shift register, PMOD debug pins.
4. Inputs: single-ended `LPB` inputs, then the LVDS inputs and outputs.
5. The `FIM2` AXI core in the signal path, with its device tree node.
6. Loading the bitstream at boot.

For each layer, `carrier.mk` lists the HDL (`HDL_SOURCES`) and constraints
(`XDC_SOURCES`, in `carriers/fim2/xdc/fim2_top.xdc`) that are loaded, and
`make CARRIER=fim2 bit` builds `build/fim2/fim2.bit` and `fim2.bit.bin`.
From layer 2 on, load `fim2.bit.bin` from Linux through the FPGA manager,
not over JTAG: BOOT.BIN has no bitstream, so its FSBL leaves the PS-PL
interfaces isolated and the PL in reset, and only a PMU firmware load
(the FPGA manager) releases them. The original
`fim2.xdc` is kept as supplied and not loaded.

The complete original design, rebuilt as a block design, is in commit
456d3d4 (`carriers/fim2/bd/fim2_bd.tcl`): the original `kria_starter_kit`
design on the repo's FIM2 PS settings with `M_AXI_HPM0_FPD` (128-bit)
enabled, `FIM2_HWInterface` and `FIM2` (`C_INPUTS` = 20) as module
references in place of the packaged `user.org:user:FIM2:3.5` IP,
SmartConnect, 8 KB AXI BRAM and processor reset. Addresses: `FIM2_0` at
0xA001_0000 (64 KB), BRAM at 0xA000_0000 (8 KB). Layers 2 to 5 bring it back
piece by piece. The block design is named `fim2_bd` (`BD_NAME` in
`carrier.mk`) because VHDL names are case-insensitive: a design named
`fim2` would generate an entity clashing with `FIM2`.

The KR260 block design is unchanged and PS-only.

Earlier tests of the rewritten FIM2 implementation do not validate these
unchanged originals.

Known problems in the carrier sources, left as supplied:

- `ALBA_carrier_wrapper.vhd` does not parse: the port list has no closing
  `);`, and `kria_starter_kit` has no ports and is not the `fim2` block design.
- `FIM2_HWInterface.vhd`: `SHR_data_out(16 downto 34)` and `(35 downto 40)`
  are null ranges, and bits 44 to 47 are never driven. Vivado 2025.2 ignores
  the two assignments (`Synth 8-3919`), so no front-panel LED data is sent;
  Vivado 2026.1 rejects them (`Synth 8-690`).
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
