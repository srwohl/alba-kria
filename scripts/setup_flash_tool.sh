#!/usr/bin/env bash
# Official AMD Embedded Platform Flash Update Tool, release v8.0.
# https://github.com/Xilinx/embpf-bootfw-update-tool/releases/tag/v8.0
set -euo pipefail
repo_dir=$(realpath "${1:?repository directory required}")
tools_dir="$repo_dir/build/tools"
destination="$tools_dir/amd-flash-v8.0"

for tool in curl tar unzip sha256sum; do
    command -v "$tool" >/dev/null || { echo "Missing prerequisite: $tool" >&2; exit 1; }
done
mkdir -p "$tools_dir"
staging=$(mktemp -d "$tools_dir/.amd-flash-XXXXXXXX")
trap 'rm -rf "$staging"' EXIT

curl --fail --location --retry 3 \
    https://api.github.com/repos/Xilinx/embpf-bootfw-update-tool/tarball/v8.0 \
    -o "$staging/source.tar.gz"
curl --fail --location --retry 3 \
    https://github.com/Xilinx/embpf-bootfw-update-tool/releases/download/v8.0/bin.zip \
    -o "$staging/bin.zip"
(
    cd "$staging"
    sha256sum --check <<'SHA256'
037225e50c3b827bb2ff6f1d2402a14e40a637a0ac58cac5f282f1e141e34bcf  source.tar.gz
bd34abcaf31c979dc08326d26b86878ea3028b3d29500c78653f71b2cacf2ea7  bin.zip
SHA256
)
mkdir "$staging/tool"
tar -xzf "$staging/source.tar.gz" --strip-components=1 -C "$staging/tool"
unzip -q "$staging/bin.zip" -d "$staging/tool"
for file in prog.sh ddr_reserved_mem_check.sh zynqmp/jtag_boot.tcl \
    bin/zynqmp_fsbl_k26.elf bin/system_k26_jtag_uart.dtb \
    bin/pmufw.elf bin/u-boot.elf bin/bl31.elf; do
    test -s "$staging/tool/$file" || { echo "Incomplete AMD release: $file" >&2; exit 1; }
done
chmod +x "$staging/tool/prog.sh" "$staging/tool/ddr_reserved_mem_check.sh"
# Preserve the checked archives for provenance. Replace only this generated tool.
mv "$staging/source.tar.gz" "$staging/bin.zip" "$staging/tool/"
rm -rf "$destination"
mv "$staging/tool" "$destination"
touch "$destination/.ready"
printf 'AMD flash tool v8.0 ready: %s\n' "$destination"
