#!/usr/bin/env bash
# Run every tests/test-*.sh. Exit 1 if any fails.
cd "$(dirname "$0")/.."
rc=0
for t in tests/test-*.sh; do
  echo "== $t"
  bash "$t" || rc=1
done
exit $rc
