# Use Vivado 2026.1 for xsa/sdt and a separate EDF/Yocto shell for machine/boot.
VIVADO ?= vivado
SDTGEN ?= sdtgen
DTC ?= dtc
DTS_CPP ?= cpp
GEN_MACHINE_CONF ?= gen-machine-conf
MACHINE ?= zynqmp-fim2-sdt
REPO ?= repo
SYNC_JOBS ?= 4
BITBAKE ?= bitbake
BOOT_CONFIG ?= $(CURDIR)/board/ps-only.conf
# Set empty on hosts that do not need the namespace-enabled AppArmor profile.
APPARMOR_PROFILE ?= bitbake
XSDB ?= xsdb
IMAGE ?=
DRY_RUN ?= 0
# Optional remote hw_server host name/IP, without :3121.
HW_SERVER ?=

.DEFAULT_GOAL := xsa
.DELETE_ON_ERROR:
.PHONY: setup xsa sdt machine boot flash-tool flash-qspi flash-emmc

setup:
	bash scripts/setup_edf.sh "$(CURDIR)" "$(REPO)" "$(SYNC_JOBS)"

xsa: build/fim2.xsa

# Keep Vivado's auxiliary files inside the ignored build directory.
build/fim2.xsa: board/fim2.tcl scripts/export_xsa.tcl Makefile
	@command -v "$(VIVADO)" >/dev/null 2>&1 || { echo "Vivado not found. Source Vivado 2026.1 settings64.sh or set VIVADO=/path/to/vivado." >&2; exit 1; }
	mkdir -p build
	cd build && "$(VIVADO)" -mode batch -notrace -source ../scripts/export_xsa.tcl -log vivado.log -journal vivado.jou
	@test -s "$@" || { echo "Vivado did not produce $@" >&2; exit 1; }

sdt: build/sdt/.generated

# Edit board/fim2.dtsi, rather than generated files under build/sdt/.
build/sdt/.generated: build/fim2.xsa board/fim2.dtsi Makefile
	@command -v "$(SDTGEN)" >/dev/null 2>&1 || { echo "SDTGen not found. Add the 2026.1 tools to PATH or set SDTGEN=/path/to/sdtgen." >&2; exit 1; }
	@command -v "$(DTC)" >/dev/null 2>&1 || { echo "Device-tree compiler not found. Add the 2026.1 tools to PATH or set DTC=/path/to/dtc." >&2; exit 1; }
	@command -v "$(DTS_CPP)" >/dev/null 2>&1 || { echo "C preprocessor not found. Install cpp or set DTS_CPP=/path/to/cpp." >&2; exit 1; }
	rm -f "$@"
	mkdir -p build/sdt
	(cd build && "$(SDTGEN)" -xsa fim2.xsa -dir sdt -user_dts "$(CURDIR)/board/fim2.dtsi" > sdtgen.log 2>&1) || { cat build/sdtgen.log; exit 1; }
	@test -s build/sdt/system-top.dts || { echo "SDTGen did not produce system-top.dts" >&2; exit 1; }
	"$(DTS_CPP)" -nostdinc -undef -D__DTS__ -x assembler-with-cpp -I build/sdt -I build/sdt/include build/sdt/system-top.dts -o build/sdt/system-top.pp.dts
	"$(DTC)" -I dts -O dtb -o build/sdt/system-top.dtb build/sdt/system-top.pp.dts 2> build/sdt/dtc.log || { cat build/sdt/dtc.log; exit 1; }
	touch "$@"

# On this Ubuntu host: aa-exec -p bitbake -- make machine
machine:
	bash scripts/generate_machine.sh "$(CURDIR)" "$(GEN_MACHINE_CONF)" "$(MACHINE)"

# Build the PS-only image in the initialized Yocto shell.
boot:
	@test -n "$$BUILDDIR" && test "$$(realpath "$$BUILDDIR")" = "$(CURDIR)/build/yocto" || { echo "Source build/edf/edf-init-build-env with build/yocto as the build directory first." >&2; exit 1; }
	@test -z "$$XILINX_VIVADO$$XILINX_VITIS$$PETALINUX" || { echo "Use a separate Yocto shell without Vivado/Vitis/PetaLinux settings." >&2; exit 1; }
	@test -s "build/yocto/conf/machine/$(MACHINE).conf" || { echo "Run make machine first." >&2; exit 1; }
	@command -v "$(BITBAKE)" >/dev/null || { echo "BitBake is not on PATH; initialize the Yocto environment first." >&2; exit 1; }
	@test -s "$(BOOT_CONFIG)" || { echo "Boot configuration not found: $(BOOT_CONFIG)" >&2; exit 1; }
	cd build/yocto && if test -n "$(APPARMOR_PROFILE)"; then \
		aa-exec -p "$(APPARMOR_PROFILE)" -- env MACHINE="$(MACHINE)" "$(BITBAKE)" -R "$(BOOT_CONFIG)" xilinx-bootbin; \
	else \
		env MACHINE="$(MACHINE)" "$(BITBAKE)" -R "$(BOOT_CONFIG)" xilinx-bootbin; \
	fi

flash-tool: build/tools/amd-flash-v8.0/.ready

build/tools/amd-flash-v8.0/.ready: scripts/setup_flash_tool.sh
	bash scripts/setup_flash_tool.sh "$(CURDIR)"

# Run in the Vivado/XSDB shell; DRY_RUN=1 never accesses hardware.
flash-qspi: flash-tool
	bash scripts/flash.sh "$(CURDIR)" qspi "$(IMAGE)" "$(XSDB)" "$(DRY_RUN)" "$(HW_SERVER)"

flash-emmc: flash-tool
	bash scripts/flash.sh "$(CURDIR)" emmc "$(IMAGE)" "$(XSDB)" "$(DRY_RUN)" "$(HW_SERVER)"
