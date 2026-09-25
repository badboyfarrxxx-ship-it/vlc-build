#!/usr/bin/env bash
# Print the VLC commit pinned in FILE (default: VLC_COMMIT), or fail.
set -euo pipefail
file="${1:-VLC_COMMIT}"
if [ ! -f "$file" ]; then
  echo "read-commit: $file not found" >&2
  exit 1
fi
sha="$(tr -d '[:space:]' < "$file" | tr 'A-F' 'a-f')"
if ! [[ "$sha" =~ ^[0-9a-f]{40}$ ]]; then
  echo "read-commit: $file must hold one full 40-character commit hash, not '$sha'" >&2
  exit 1
fi
echo "$sha"
