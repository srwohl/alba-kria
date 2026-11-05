# FIM2: Kria K26 build flow. Run `make help` for the target list.
#
# The flow spans three shells; each section below names the one it needs:
#   vivado  source <install>/2026.1/Vivado/settings64.sh
#   host    a fresh shell with no Vivado or Yocto settings
#   yocto   source build/edf/edf-init-build-env build/yocto
#
# The logic lives in scripts/; this file only wires stages together.

include project.mk

# ---- Tools: override on the command line, e.g. make VIVADO=/path/to/vivado
VIVADO           ?= vivado
SDTGEN           ?= sdtgen
DTC              ?= dtc
DTS_CPP          ?= cpp
XSDB             ?= xsdb
REPO             ?= repo
BITBAKE          ?= bitbake
GEN_MACHINE_CONF ?= gen-machine-conf

# ---- Options
SYNC_JOBS        ?= 4
BOOT_CONFIG      ?= $(CURDIR)/sw/yocto/ps-only.conf
# Set empty on hosts that do not need the namespace-enabled AppArmor profile.
APPARMOR_PROFILE ?= bitbake
# Flashing: IMAGE=path, DRY_RUN=1 prints the command only, HW_SERVER=host
IMAGE            ?=
DRY_RUN          ?= 0
HW_SERVER        ?=

# ---- Sources and outputs
BD_TCL     := hw/bd/$(PROJECT)_ps.tcl
DTSI       := sw/dts/$(PROJECT).dtsi
BUILD      := build
LOGS       := $(BUILD)/logs
XSA        := $(BUILD)/$(PROJECT).xsa
SDT        := $(BUILD)/sdt/.generated
FLASH_TOOL := $(BUILD)/tools/amd-flash-v8.0/.ready

# $(call require,VAR,hint): fail early if the tool named by $(VAR) is missing.
require = @command -v "$($(1))" >/dev/null 2>&1 || { echo "$(1)=$($(1)) not found. $(2)" >&2; exit 1; }

.DEFAULT_GOAL := help
.DELETE_ON_ERROR:
.PHONY: help xsa sdt setup machine boot flash-tool flash-qspi flash-emmc clean

##@ General

help: ## Show this list
	@awk 'BEGIN { FS = ":.*## " } \
	    /^##@/ { printf "\n%s\n", substr($$0, 5) } \
	    /^[a-z][a-z-]*:.*## / { printf "  %-12s %s\n", $$1, $$2 }' $(MAKEFILE_LIST)
	@echo

##@ Hardware (vivado shell)

xsa: $(XSA) ## Export hardware handoff to build/fim2.xsa
sdt: $(SDT) ## Generate system device tree in build/sdt

$(XSA): $(BD_TCL) scripts/vivado/export_xsa.tcl project.mk
	$(call require,VIVADO,Source Vivado $(TOOL_VERSION) settings64.sh or set VIVADO=/path/to/vivado.)
	@mkdir -p $(LOGS)
	cd $(BUILD) && "$(VIVADO)" -mode batch -notrace -log logs/vivado.log -journal logs/vivado.jou \
	    -source $(CURDIR)/scripts/vivado/export_xsa.tcl \
	    -tclargs $(PART) $(BOARD_PART) $(TOOL_VERSION) $(CURDIR)/$(BD_TCL) $(CURDIR)/$(XSA)
	@test -s $@ || { echo "Vivado did not produce $@" >&2; exit 1; }

$(SDT): $(XSA) $(DTSI) scripts/gen_sdt.sh
	bash scripts/gen_sdt.sh "$(CURDIR)" "$(SDTGEN)" "$(DTC)" "$(DTS_CPP)"

##@ Software (setup: host shell; machine, boot: yocto shell)

setup: ## Fetch pinned EDF sources into build/edf
	bash scripts/setup_edf.sh "$(CURDIR)" "$(REPO)" "$(SYNC_JOBS)" "$(EDF_RELEASE)"

# On this Ubuntu host: aa-exec -p bitbake -- make machine
machine: ## Generate the Yocto machine conf from the SDT
	bash scripts/generate_machine.sh "$(CURDIR)" "$(GEN_MACHINE_CONF)" "$(MACHINE)" "$(TOOL_VERSION)"

boot: ## Build BOOT.BIN (xilinx-bootbin)
	bash scripts/build_boot.sh "$(CURDIR)" "$(BITBAKE)" "$(MACHINE)" "$(BOOT_CONFIG)" "$(APPARMOR_PROFILE)"

##@ Programming (vivado shell; DRY_RUN=1 never touches hardware)

flash-tool: $(FLASH_TOOL) ## Download and verify the AMD flash tool v8.0
flash-qspi: $(FLASH_TOOL) ## Write BOOT.BIN to QSPI: IMAGE=path/BOOT.BIN
	bash scripts/flash.sh "$(CURDIR)" qspi "$(IMAGE)" "$(XSDB)" "$(DRY_RUN)" "$(HW_SERVER)"
flash-emmc: $(FLASH_TOOL) ## Write a disk image to eMMC: IMAGE=path/image.wic.gz
	bash scripts/flash.sh "$(CURDIR)" emmc "$(IMAGE)" "$(XSDB)" "$(DRY_RUN)" "$(HW_SERVER)"

$(FLASH_TOOL): scripts/setup_flash_tool.sh
	bash scripts/setup_flash_tool.sh "$(CURDIR)"

##@ Housekeeping

clean: ## Remove Vivado and SDT outputs (keeps EDF, Yocto and tools)
	rm -rf $(BUILD)/vivado $(XSA) $(BUILD)/sdt $(LOGS) $(BUILD)/.Xil
