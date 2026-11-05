#!/usr/bin/env bash
# Build a BitBake target (BOOT.BIN, a disk image) for one carrier's machine.
# Run in the Yocto shell: source build/edf/edf-init-build-env build/yocto
set -euo pipefail

repo_dir=$(realpath "${1:?repository directory required}")
bitbake=${2:-bitbake}
machine=${3:?machine required}
# Empty on hosts that do not need the namespace-enabled AppArmor profile.
apparmor_profile=${4-bitbake}
target=${5:?BitBake target required}
yocto_dir="$repo_dir/build/yocto"

fail() { printf 'Yocto build: %s\n' "$*" >&2; exit 1; }

[[ -n "${BUILDDIR:-}" && "$(realpath "$BUILDDIR")" == "$yocto_dir" ]] ||
    fail "source build/edf/edf-init-build-env with $yocto_dir as the build directory first."
[[ -z "${XILINX_VIVADO:-}${XILINX_VITIS:-}${PETALINUX:-}" ]] ||
    fail 'use a separate Yocto shell without Vivado/Vitis/PetaLinux settings.'
[[ -s "$yocto_dir/conf/machine/$machine.conf" ]] || fail 'run make machine first.'
command -v "$bitbake" >/dev/null || fail 'BitBake is not on PATH; initialize the Yocto environment first.'
grep -q '/meta-alba-kria ' "$yocto_dir/conf/bblayers.conf" ||
    fail 'build/yocto was not created from meta-alba-kria; move it aside and run make setup.'
# One Yocto build directory serves every carrier, so MACHINE must come from
# the environment. A hard assignment in local.conf would silently override it.
! grep -Eq '^[[:space:]]*MACHINE[[:space:]]*=' "$yocto_dir/conf/local.conf" ||
    fail "conf/local.conf assigns MACHINE, which would override $machine; remove that line."

cmd=(env MACHINE="$machine" "$bitbake" "$target")
[[ -z "$apparmor_profile" ]] || cmd=(aa-exec -p "$apparmor_profile" -- "${cmd[@]}")
cd "$yocto_dir"
exec "${cmd[@]}"
