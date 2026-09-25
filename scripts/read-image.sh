#!/usr/bin/env bash
# Print the Windows x86_64 build image VLC's own CI uses, read from its gitlab-ci.yml.
set -euo pipefail
ci="${1:?usage: read-image.sh path/to/gitlab-ci.yml}"
if [ ! -f "$ci" ]; then
  echo "read-image: $ci not found" >&2
  exit 1
fi
img="$(sed -n 's/^[[:space:]]*VLC_WIN64_IMAGE:[[:space:]]*//p' "$ci" | head -n 1 | tr -d "\"'[:space:]")"
if [ -z "$img" ]; then
  echo "read-image: no VLC_WIN64_IMAGE in $ci" >&2
  exit 1
fi
case "$img" in
  registry.videolan.org/*) echo "$img" ;;
  *) echo "read-image: unexpected image '$img', expected one from registry.videolan.org" >&2; exit 1 ;;
esac
