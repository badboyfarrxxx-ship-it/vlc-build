#!/usr/bin/env bash
set -uo pipefail
cd "$(dirname "$0")/.."
. tests/lib.sh
tmp="$(mktemp -d)"

# A toy git repo with one file, reset to "line1" before each case.
repo="$tmp/repo"
git init -q "$repo"
printf 'line1\n' > "$repo/a.txt"
git -C "$repo" add a.txt
git -C "$repo" -c user.name=t -c user.email=t@t commit -qm init
reset_repo() { git -C "$repo" checkout -q -- . && git -C "$repo" clean -qfd; }

# Patch "first" turns line1 into line2; patch "second" turns line2 into line3.
# "second" only applies after "first", which proves the order.
mkdir -p "$tmp/p-order" "$tmp/p-empty" "$tmp/p-bad" "$tmp/p-readme"
printf 'line2\n' > "$repo/a.txt"; git -C "$repo" diff > "$tmp/p-order/0002-first.patch"
git -C "$repo" add a.txt; printf 'line3\n' > "$repo/a.txt"; git -C "$repo" diff > "$tmp/p-order/0010-second.patch"
git -C "$repo" reset -q; reset_repo
cp "$tmp/p-order/0010-second.patch" "$tmp/p-bad/0001-needs-line2.patch"
echo "notes" > "$tmp/p-readme/README.md"

expect_ok "no patches: succeeds" scripts/apply-patches.sh "$repo" "$tmp/p-empty"
expect_output "no patches: tree unchanged" "line1" cat "$repo/a.txt"

expect_ok "only a README: succeeds" scripts/apply-patches.sh "$repo" "$tmp/p-readme"
expect_output "only a README: tree unchanged" "line1" cat "$repo/a.txt"

expect_ok "two patches: succeed" scripts/apply-patches.sh "$repo" "$tmp/p-order"
expect_output "two patches: applied in name order" "line3" cat "$repo/a.txt"
reset_repo

expect_fail "bad patch: fails" scripts/apply-patches.sh "$repo" "$tmp/p-bad"
reset_repo
expect_output_contains "bad patch: named in the error" "0001-needs-line2.patch does not apply" \
  scripts/apply-patches.sh "$repo" "$tmp/p-bad"
reset_repo

expect_fail "missing arguments: fails" scripts/apply-patches.sh "$repo"

rm -rf "$tmp"
finish
