#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."
. tests/lib.sh
tmp="$(mktemp -d)"
img=registry.videolan.org/vlc-debian-win64-posix:20260611225331

# Same shape as the top of VLC's extras/ci/gitlab-ci.yml.
cat > "$tmp/real.yml" <<EOF
variables:
    VLC_WIN64_IMAGE: $img
    VLC_WIN_LLVM_MSVCRT_IMAGE: registry.videolan.org/vlc-debian-llvm-msvcrt:20260611225331
EOF
cat > "$tmp/quoted.yml" <<EOF
variables:
    VLC_WIN64_IMAGE: "$img"
EOF
cat > "$tmp/missing.yml" <<EOF
variables:
    VLC_DEBIAN_IMAGE: registry.videolan.org/vlc-debian-unstable:20260611225331
EOF
cat > "$tmp/elsewhere.yml" <<EOF
variables:
    VLC_WIN64_IMAGE: docker.io/someone/vlc:latest
EOF

expect_output "reads the image" "$img" scripts/read-image.sh "$tmp/real.yml"
expect_output "strips quotes" "$img" scripts/read-image.sh "$tmp/quoted.yml"
expect_fail "missing variable: fails" scripts/read-image.sh "$tmp/missing.yml"
expect_output_contains "missing variable: says so" "no VLC_WIN64_IMAGE" scripts/read-image.sh "$tmp/missing.yml"
expect_fail "image outside registry.videolan.org: fails" scripts/read-image.sh "$tmp/elsewhere.yml"
expect_fail "missing file: fails" scripts/read-image.sh "$tmp/nope.yml"

rm -rf "$tmp"
finish
