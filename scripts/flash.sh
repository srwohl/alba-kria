#!/usr/bin/env bash
# Explicit hardware operation; no build target programs flash automatically.
set -euo pipefail
repo_dir=$(realpath "${1:?repository directory required}")
medium=${2:?qspi or emmc required}
image=${3:-}
xsdb=${4:-xsdb}
dry_run=${5:-0}
server=${6:-}
tool_dir="$repo_dir/build/tools/amd-flash-v8.0"
fail() { printf 'Flash: %s\n' "$*" >&2; exit 1; }

[[ "$dry_run" == 0 || "$dry_run" == 1 ]] || fail 'DRY_RUN must be 0 or 1.'
[[ -n "$image" ]] || fail "provide IMAGE=/path/to/boot.bin for QSPI or IMAGE=/path/to/image.wic.gz for eMMC."
[[ -s "$image" && -f "$image" ]] || fail "image missing or empty: $image"
image=$(realpath "$image")
[[ -z "${BUILDDIR:-}${PETALINUX:-}" ]] || fail 'use a separate Vivado/XSDB shell, without the Yocto/PetaLinux environment.'
xsdb_path=$(command -v "$xsdb") || fail 'XSDB not found; source Vivado settings64.sh or set XSDB=/path/to/xsdb.'
xsdb_path=$(realpath "$xsdb_path")
export PATH="$(dirname "$xsdb_path"):$PATH"
[[ -s "$tool_dir/prog.sh" && -s "$tool_dir/bin/zynqmp_fsbl_k26.elf" ]] || fail 'run make flash-tool first.'

args=(-d kria_k26 -pv -i "$image" -V)
case "$medium" in
    qspi)
        [[ "${image,,}" == *.bin ]] || fail 'QSPI expects an uncompressed .bin boot image.'
        # sw/dts/fim2.dtsi allocates [0, 0x200000) to the raw boot image.
        (( $(stat -c %s "$image") <= 0x200000 )) || fail 'boot image exceeds the 2 MiB QSPI boot partition; review the flash layout first.'
        args+=(-a 0x0)
        ;;
    emmc)
        [[ "$image" == *.wic.gz ]] || fail 'eMMC expects a gzip-compressed disk image (.wic.gz), not BOOT.BIN or .wic.xz.'
        gzip -t "$image" || fail 'invalid gzip image.'
        args+=(-E)
        ;;
    *) fail "unsupported medium: $medium" ;;
esac
[[ -z "$server" ]] || args+=(-w "$server")
printf 'Target: K26 %s; image: %s\n' "$medium" "$image"
printf 'Command: bash %q' "$tool_dir/prog.sh"
printf ' %q' "${args[@]}"
printf '\n'
if [[ "$dry_run" == 1 ]]; then
    echo 'Dry run: no JTAG connections, resets, or flash writes performed.'
    exit 0
fi
if [[ "$medium" == emmc ]]; then
    echo 'Writing the eMMC user area from block zero, including its partition table.'
else
    echo 'Writing raw BOOT.BIN at QSPI offset zero, replacing the existing boot image.'
fi
# Upstream creates temporary files in its working directory. Keep them in build/.
# Its K26 helper selects targets by name: connect only the intended board.
cd "$tool_dir"
exec bash ./prog.sh "${args[@]}"
