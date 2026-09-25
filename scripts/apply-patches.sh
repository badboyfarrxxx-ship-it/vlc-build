#!/usr/bin/env bash
# Apply every *.patch in PATCH_DIR to the git tree at VLC_DIR, in name order.
# Stops at the first patch that doesn't apply and names it.
set -euo pipefail
if [ $# -ne 2 ]; then
  echo "usage: apply-patches.sh VLC_DIR PATCH_DIR" >&2
  exit 1
fi
vlc_dir="$1"
patch_dir="$2"
export LC_ALL=C
shopt -s nullglob
patches=("$patch_dir"/*.patch)
if [ ${#patches[@]} -eq 0 ]; then
  echo "apply-patches: no patches in $patch_dir, building stock VLC"
  exit 0
fi
for p in "${patches[@]}"; do
  name="$(basename "$p")"
  echo "apply-patches: $name"
  if ! git -C "$vlc_dir" apply --whitespace=nowarn "$(realpath "$p")"; then
    echo "apply-patches: $name does not apply to this VLC commit" >&2
    exit 1
  fi
done
