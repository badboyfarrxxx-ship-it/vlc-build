#!/usr/bin/env bash
# Check a VLC Windows zip holds the files a working player needs.
set -euo pipefail
zip="${1:?usage: check-package.sh vlc-VERSION-win64.zip}"
if [ ! -f "$zip" ]; then
  echo "check-package: $zip not found" >&2
  exit 1
fi
if ! list="$(unzip -Z1 "$zip" 2>/dev/null)"; then
  echo "check-package: $zip is not a readable zip" >&2
  exit 1
fi
required=(
  vlc.exe
  libvlc.dll
  libvlccore.dll
  plugins/gui/libqt_plugin.dll
  plugins/codec/libavcodec_plugin.dll
)
missing=0
for f in "${required[@]}"; do
  # Each file must sit exactly one folder below the zip root, e.g. vlc-4.0.0-dev/vlc.exe.
  if ! printf '%s\n' "$list" | grep -qxE "[^/]+/${f//./\\.}"; then
    echo "missing: $f" >&2
    missing=$((missing + 1))
  fi
done
if [ "$missing" -gt 0 ]; then
  echo "check-package: $zip is missing $missing required file(s)" >&2
  exit 1
fi
echo "check-package: ok ($(printf '%s\n' "$list" | wc -l) files)"
