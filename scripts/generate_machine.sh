#!/usr/bin/env bash
# Generate the Yocto machine using the official 2026.1 parse-sdt flow:
# https://edf.docs.amd.com/en/v26.06.1/shel/running-gen-machine-conf.html
#
# Prerequisites:
#   1. Run make sdt in the Vivado environment (per carrier: CARRIER=<name>).
#   2. In a NEW shell, run make setup to fetch the pinned EDF workspace.
#   3. Source the environment command it prints (build/yocto already exists,
#      created from meta-alba-kria's templates); this also puts the release's
#      gen-machine-conf on PATH.
#   4. From this repository, run make machine.
#
# The Yocto environment/layers must already be configured: sourcing an
# arbitrary poky checkout alone does not supply the AMD layers or tools.
set -euo pipefail

repo_dir=$(realpath "${1:?repository directory required}")
generator=${2:-gen-machine-conf}
machine=${3:?machine required}
tool_version=${4:-2026.1}
# Per-carrier build directory holding sdt/; machine/ is written next to it.
carrier_dir=$(realpath -m "${5:?carrier build directory required}")
yocto_dir="$repo_dir/build/yocto"
sdt_dir="$carrier_dir/sdt"
output_dir="$carrier_dir/machine"

fail() { printf 'Machine generation: %s\n' "$*" >&2; exit 1; }

[[ "$machine" =~ ^[a-z0-9][a-z0-9-]*$ ]] || fail "invalid MACHINE name: $machine"
[[ -s "$sdt_dir/system-top.dts" && -s "$sdt_dir/system-top.dtb" && -f "$sdt_dir/.generated" ]] ||
    fail 'validated SDT missing; run make sdt in the Vivado shell first.'
[[ -z "${XILINX_VIVADO:-}${XILINX_VITIS:-}${PETALINUX:-}" ]] ||
    fail 'use a new shell with the AMD 2026.1 Yocto environment, without sourcing Vivado/Vitis/PetaLinux settings.'
[[ -n "${BUILDDIR:-}" ]] ||
    fail "AMD 2026.1 Yocto environment is not active. Initialize it with build directory $yocto_dir, then run make machine from $repo_dir."
[[ "$(realpath "$BUILDDIR")" == "$yocto_dir" ]] ||
    fail "initialize the Yocto environment for $yocto_dir (current BUILDDIR is $BUILDDIR)."
[[ -s "$yocto_dir/conf/bblayers.conf" && -s "$yocto_dir/conf/local.conf" ]] ||
    fail "Yocto configuration missing under $yocto_dir/conf; run make setup first."
grep -q '/meta-alba-kria ' "$yocto_dir/conf/bblayers.conf" ||
    fail 'build/yocto was not created from meta-alba-kria; move it aside and run make setup.'
command -v bitbake >/dev/null || fail 'bitbake is not on PATH; initialize the Yocto environment first.'
generator_path=$(command -v "$generator") || fail "cannot find $generator; add the 2026.1 gen-machine-conf directory to PATH or set GEN_MACHINE_CONF."
generator_path=$(realpath "$generator_path")

# gen-machine-conf expects TOPDIR as its working directory. Its version check
# also runs there, so any tool-created files stay under the ignored build/.
cd "$yocto_dir"
version=$("$generator_path" --version 2>&1) || fail "$version"
version_re="Gen Machine Conf v${tool_version//./\\.}([^0-9.]|\$)"
[[ "$version" =~ $version_re ]] ||
    fail "expected gen-machine-conf $tool_version, got: $version"
# Start from scratch: gen-machine-conf keeps its settings in $output_dir and
# ignores a changed --machine-name once that config exists (2026.1).
rm -rf "$output_dir"
mkdir -p "$output_dir"
printf '%s\n' "$version" > "$output_dir/tool-version.txt"
# No -l: it would append a hard MACHINE = "<machine>" to the shared
# local.conf on every run, and the last carrier generated would then win for
# every build. build_boot.sh passes MACHINE per carrier instead.
"$generator_path" parse-sdt \
    --hw-description "$sdt_dir" \
    --machine-name "$machine" \
    -c "$yocto_dir/conf" \
    --output "$output_dir" \
    > "$output_dir/console.log" 2>&1 || {
        cat "$output_dir/console.log" >&2
        fail "gen-machine-conf failed; see $output_dir/console.log"
    }
[[ -s "$yocto_dir/conf/machine/$machine.conf" ]] ||
    fail "tool returned success without producing conf/machine/$machine.conf"
printf 'Generated %s\nLogs and intermediate files: %s\n' \
    "$yocto_dir/conf/machine/$machine.conf" "$output_dir"
