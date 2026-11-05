#!/usr/bin/env bash
# Fetch AMD EDF sources without mixing the software and Vivado environments.
# Host packages must be installed separately (this script does not use sudo).
set -euo pipefail

repo_dir=$(realpath "${1:?repository directory required}")
repo_tool=${2:-repo}
sync_jobs=${3:-4}
release=amd-edf-rel-v26.06.1
manifest_url=https://github.com/Xilinx/yocto-manifests.git
edf_dir="$repo_dir/build/edf"

fail() { printf 'EDF setup: %s\n' "$*" >&2; exit 1; }

[[ "$sync_jobs" =~ ^[1-9][0-9]*$ ]] || fail 'SYNC_JOBS must be a positive integer.'
[[ -z "${XILINX_VIVADO:-}${XILINX_VITIS:-}${PETALINUX:-}${BUILDDIR:-}" ]] ||
    fail 'run make setup in a fresh Bash terminal before sourcing Vivado, Vitis, PetaLinux, or Yocto settings.'
command -v git >/dev/null || fail 'git is not installed.'
repo_path=$(command -v "$repo_tool") || fail 'repo is not installed; install the Google Repo tool or set REPO=/path/to/repo.'
repo_path=$(realpath "$repo_path")

mkdir -p "$edf_dir"
cd "$edf_dir"
# Reassert the release on each invocation; sync resumes downloads and leaves
# source modifications under Repo's normal conflict handling.
"$repo_path" init -u "$manifest_url" \
    -b "refs/tags/$release" -m default-edf.xml
"$repo_path" sync -j"$sync_jobs"
[[ -s edf-init-build-env ]] || fail 'sync completed without edf-init-build-env.'
# Record all checked-out revisions for inspecting/reproducing this setup.
"$repo_path" manifest -r -o "$repo_dir/build/edf-manifest.xml"

printf '\nEDF %s sources ready. In this terminal, run:\n\n' "$release"
# A child process cannot activate an environment in the parent terminal.
printf 'source %q %q\n' "$edf_dir/edf-init-build-env" "$repo_dir/build/yocto"
printf 'cd %q\nmake machine\n' "$repo_dir"
