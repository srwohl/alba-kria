#!/usr/bin/env bash
# Load a bitstream into the PL of a running board through the Linux FPGA
# manager, over SSH. Unlike JTAG with a bitstream-less BOOT.BIN, the FPGA
# manager load (PMU firmware) also opens the PS-PL interfaces and resets the
# PL, so the AXI peripherals can be used afterwards.
set -euo pipefail
bitbin=${1:?bitstream (.bit.bin) required}
host=${2:-}
dry_run=${3:-0}
fail() { printf 'Load: %s\n' "$*" >&2; exit 1; }

[[ "$dry_run" == 0 || "$dry_run" == 1 ]] || fail 'DRY_RUN must be 0 or 1.'
[[ -n "$host" ]] || fail 'set BOARD_HOST=user@address (in local.mk or on the command line).'
[[ -s "$bitbin" && -f "$bitbin" ]] || fail "bitstream missing or empty: $bitbin"
[[ "$bitbin" == *.bit.bin ]] || fail 'the FPGA manager needs the .bit.bin from make bit, not the .bit.'
name=$(basename "$bitbin")
[[ "$name" =~ ^[A-Za-z0-9._-]+$ ]] || fail "unexpected file name: $name"

# Runs on the board as root. The FPGA manager loads files by name from
# /lib/firmware; flags 0 means a full bitstream.
remote="set -e
mgr=/sys/class/fpga_manager/fpga0
[ -d \$mgr ] || { echo \"No FPGA manager at \$mgr\" >&2; exit 1; }
install -D -m 0644 /tmp/$name /lib/firmware/$name
rm -f /tmp/$name
[ ! -e \$mgr/flags ] || echo 0 > \$mgr/flags
echo $name > \$mgr/firmware
state=\$(cat \$mgr/state)
echo \"FPGA manager state: \$state\"
[ \"\$state\" = operating ]"

printf 'Target: %s; bitstream: %s\n' "$host" "$bitbin"
if [[ "$dry_run" == 1 ]]; then
    printf 'Would copy it to %s:/tmp/%s and run with sudo:\n%s\n' "$host" "$name" "$remote"
    echo 'Dry run: nothing copied or loaded.'
    exit 0
fi
scp -q "$bitbin" "$host:/tmp/$name"
# -t: sudo may ask for the login user's password.
ssh -t "$host" "sudo sh -c '$remote'"
echo 'PL loaded.'
