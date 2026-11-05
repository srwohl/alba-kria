#!/usr/bin/env bash
# Build BOOT.BIN (xilinx-bootbin) for the generated machine.
# Run in the Yocto shell: source build/edf/edf-init-build-env build/yocto
set -euo pipefail

repo_dir=$(realpath "${1:?repository directory required}")
bitbake=${2:-bitbake}
machine=${3:-zynqmp-fim2-sdt}
boot_config=${4:?boot configuration required}
# Empty on hosts that do not need the namespace-enabled AppArmor profile.
apparmor_profile=${5-bitbake}
yocto_dir="$repo_dir/build/yocto"

fail() { printf 'Boot build: %s\n' "$*" >&2; exit 1; }

[[ -n "${BUILDDIR:-}" && "$(realpath "$BUILDDIR")" == "$yocto_dir" ]] ||
    fail "source build/edf/edf-init-build-env with $yocto_dir as the build directory first."
[[ -z "${XILINX_VIVADO:-}${XILINX_VITIS:-}${PETALINUX:-}" ]] ||
    fail 'use a separate Yocto shell without Vivado/Vitis/PetaLinux settings.'
[[ -s "$yocto_dir/conf/machine/$machine.conf" ]] || fail 'run make machine first.'
command -v "$bitbake" >/dev/null || fail 'BitBake is not on PATH; initialize the Yocto environment first.'
[[ -s "$boot_config" ]] || fail "boot configuration not found: $boot_config"

cmd=(env MACHINE="$machine" "$bitbake" -R "$boot_config" xilinx-bootbin)
[[ -z "$apparmor_profile" ]] || cmd=(aa-exec -p "$apparmor_profile" -- "${cmd[@]}")
cd "$yocto_dir"
exec "${cmd[@]}"
