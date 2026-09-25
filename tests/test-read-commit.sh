#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."
. tests/lib.sh
tmp="$(mktemp -d)"
good=9e59d4b38f804b33491b332df7643c1f80cc0b57

printf '%s\n' "$good" > "$tmp/plain"
printf '  %s  \n\n' "$good" > "$tmp/spaces"
printf 'master\n' > "$tmp/branch"
printf '9e59d4b\n' > "$tmp/short"
printf '%s\n' "9E59D4B38F804B33491B332DF7643C1F80CC0B57" > "$tmp/upper"
: > "$tmp/empty"

expect_output "reads a plain hash" "$good" scripts/read-commit.sh "$tmp/plain"
expect_output "ignores spaces and blank lines" "$good" scripts/read-commit.sh "$tmp/spaces"
expect_fail "rejects a branch name" scripts/read-commit.sh "$tmp/branch"
expect_fail "rejects a short hash" scripts/read-commit.sh "$tmp/short"
expect_fail "rejects an empty file" scripts/read-commit.sh "$tmp/empty"
expect_fail "rejects a missing file" scripts/read-commit.sh "$tmp/missing"
expect_output_contains "says what is wrong" "full 40-character commit hash" scripts/read-commit.sh "$tmp/branch"
expect_output "accepts upper case, prints lower case" "$good" scripts/read-commit.sh "$tmp/upper"
expect_ok "the repo's own VLC_COMMIT is valid" scripts/read-commit.sh VLC_COMMIT

rm -rf "$tmp"
finish
