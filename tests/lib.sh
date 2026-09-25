# Tiny test helpers. Source this from a test file, then call finish at the end.
fails=0
_out="$(mktemp)"

expect_ok() {
  local name="$1"; shift
  if "$@" >"$_out" 2>&1; then echo "ok   - $name"
  else echo "FAIL - $name"; sed 's/^/       /' "$_out"; fails=$((fails + 1)); fi
}

expect_fail() {
  local name="$1"; shift
  if "$@" >"$_out" 2>&1; then echo "FAIL - $name (expected a failure)"; fails=$((fails + 1))
  else echo "ok   - $name"; fi
}

expect_output() {
  local name="$1" want="$2"; shift 2
  local got; got="$("$@" 2>&1)" || true
  if [ "$got" = "$want" ]; then echo "ok   - $name"
  else echo "FAIL - $name: wanted '$want', got '$got'"; fails=$((fails + 1)); fi
}

expect_output_contains() {
  local name="$1" want="$2"; shift 2
  local got; got="$("$@" 2>&1)" || true
  if printf '%s' "$got" | grep -qF -- "$want"; then echo "ok   - $name"
  else echo "FAIL - $name: output lacks '$want':"; printf '%s\n' "$got" | sed 's/^/       /'; fails=$((fails + 1)); fi
}

finish() {
  rm -f "$_out"
  if [ "$fails" -gt 0 ]; then echo "$fails failed"; exit 1; fi
}
