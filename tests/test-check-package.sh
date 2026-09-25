#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."
. tests/lib.sh
tmp="$(mktemp -d)"

# make_zip OUT TOPDIR FILE...: a zip holding empty files under TOPDIR/.
make_zip() {
  python3 - "$@" <<'PY'
import sys, zipfile
out, top, files = sys.argv[1], sys.argv[2], sys.argv[3:]
with zipfile.ZipFile(out, "w") as z:
    for f in files:
        z.writestr(f"{top}/{f}", b"")
PY
}
all=(vlc.exe libvlc.dll libvlccore.dll plugins/gui/libqt_plugin.dll plugins/codec/libavcodec_plugin.dll lua/intf/http.lua)

make_zip "$tmp/good.zip" vlc-4.0.0-dev "${all[@]}"
make_zip "$tmp/othertop.zip" vlc-4.1.0-dev "${all[@]}"
make_zip "$tmp/noqt.zip" vlc-4.0.0-dev vlc.exe libvlc.dll libvlccore.dll plugins/codec/libavcodec_plugin.dll
make_zip "$tmp/deep.zip" vlc-4.0.0-dev/extra "${all[@]}"
make_zip "$tmp/wrongplace.zip" vlc-4.0.0-dev plugins/vlc.exe libvlc.dll libvlccore.dll \
  plugins/gui/libqt_plugin.dll plugins/codec/libavcodec_plugin.dll
echo "not a zip" > "$tmp/fake.zip"

expect_ok "complete zip: passes" scripts/check-package.sh "$tmp/good.zip"
expect_ok "any top folder name: passes" scripts/check-package.sh "$tmp/othertop.zip"
expect_fail "no Qt interface: fails" scripts/check-package.sh "$tmp/noqt.zip"
expect_output_contains "no Qt interface: names it" "missing: plugins/gui/libqt_plugin.dll" \
  scripts/check-package.sh "$tmp/noqt.zip"
expect_fail "files two folders down: fails" scripts/check-package.sh "$tmp/deep.zip"
expect_fail "vlc.exe in the wrong folder: fails" scripts/check-package.sh "$tmp/wrongplace.zip"
expect_fail "not a zip: fails" scripts/check-package.sh "$tmp/fake.zip"
expect_fail "missing file: fails" scripts/check-package.sh "$tmp/nope.zip"

rm -rf "$tmp"
finish
