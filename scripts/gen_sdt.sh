#!/usr/bin/env bash
# Generate the system device tree from the XSA plus sw/dts/fim2.dtsi, then
# compile it once so syntax and reference errors surface here rather than in
# gen-machine-conf. Edit sw/dts/fim2.dtsi, never the files under build/sdt/.
set -euo pipefail

repo_dir=$(realpath "${1:?repository directory required}")
sdtgen=${2:-sdtgen}
dtc=${3:-dtc}
cpp=${4:-cpp}
xsa="$repo_dir/build/fim2.xsa"
user_dts="$repo_dir/sw/dts/fim2.dtsi"
sdt_dir="$repo_dir/build/sdt"
log_dir="$repo_dir/build/logs"

fail() { printf 'SDT generation: %s\n' "$*" >&2; exit 1; }

command -v "$sdtgen" >/dev/null || fail "SDTGen not found; source Vivado settings64.sh or set SDTGEN=/path/to/sdtgen."
command -v "$dtc" >/dev/null || fail "device-tree compiler not found; source Vivado settings64.sh or set DTC=/path/to/dtc."
command -v "$cpp" >/dev/null || fail "C preprocessor not found; install cpp or set DTS_CPP=/path/to/cpp."
[[ -s "$xsa" ]] || fail "missing $xsa; run make xsa first."

# Remove the stamp first so a failed run never looks up to date.
rm -f "$sdt_dir/.generated"
mkdir -p "$sdt_dir" "$log_dir"
(cd "$repo_dir/build" && "$sdtgen" -xsa "$xsa" -dir "$sdt_dir" -user_dts "$user_dts") \
    > "$log_dir/sdtgen.log" 2>&1 || { cat "$log_dir/sdtgen.log" >&2; fail "sdtgen failed; see $log_dir/sdtgen.log"; }
[[ -s "$sdt_dir/system-top.dts" ]] || fail 'sdtgen did not produce system-top.dts.'

"$cpp" -nostdinc -undef -D__DTS__ -x assembler-with-cpp \
    -I "$sdt_dir" -I "$sdt_dir/include" \
    "$sdt_dir/system-top.dts" -o "$sdt_dir/system-top.pp.dts"
"$dtc" -I dts -O dtb -o "$sdt_dir/system-top.dtb" "$sdt_dir/system-top.pp.dts" \
    2> "$log_dir/dtc.log" || { cat "$log_dir/dtc.log" >&2; fail "dtc failed; see $log_dir/dtc.log"; }
touch "$sdt_dir/.generated"
