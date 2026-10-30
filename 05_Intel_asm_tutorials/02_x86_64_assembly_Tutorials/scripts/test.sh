#!/bin/bash
# -----------------------------------------------------------------------------
# test.sh -- run every example and verify against the chapter tests.txt
#
# Manifest format (see docs/SPEC.md):
#   <name>  <kind>  <expected>  [stdin|-]  [args...]
# kinds: exit | out | outc | signal
#   exit   -> $? must equal expected
#   out    -> stdout must equal expected exactly (\n = newline)
#   outc   -> stdout must contain expected
#   signal -> process must die from signal expected (e.g. 8 = SIGFPE)
#
# Usage:
#   scripts/test.sh                    run all tests
#   scripts/test.sh ch13_system_services   one chapter only
# -----------------------------------------------------------------------------
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BIN="$ROOT/bin"

if [ ! -d "$BIN" ]; then
    echo "bin/ is empty -- run scripts/build.sh first"
    exit 1
fi

FILTER="${1:-}"
PASS=0
FAIL=0
FAILED_LIST=()

run_case() {
    local name="$1" kind="$2" expect="$3" stdin_data="${4:--}" ; shift 4 || true
    local -a args=("$@")

    [ -x "$BIN/$name" ] || { echo "FAIL  $name      (missing binary)"; FAIL=$((FAIL+1)); FAILED_LIST+=("$name"); return; }

    local out rc
    if [ "$stdin_data" = "-" ]; then
        out="$("$BIN/$name" "${args[@]}" 2>/dev/null)"
        rc=$?
    else
        out="$(printf '%b' "$stdin_data" | "$BIN/$name" "${args[@]}" 2>/dev/null)"
        rc=$?
    fi

    local ok=0 detail=""
    case "$kind" in
        exit)
            [ "$rc" -eq "$expect" ] && ok=1 || detail="want exit $expect, got $rc" ;;
        out)
            local want; want="$(printf '%b' "$expect")"
            [ "$out" = "$want" ] && ok=1 || detail="want stdout [$want], got [$out]" ;;
        outc)
            local want; want="$(printf '%b' "$expect")"
            case "$out" in *"$want"*) ok=1 ;; *) detail="stdout [$out] lacks [$want]" ;; esac ;;
        signal)
            [ $((rc - 128)) -eq "$expect" ] && ok=1 || detail="want signal $expect (rc $((128+expect))), got rc $rc" ;;
        *)
            detail="unknown kind '$kind'" ;;
    esac

    if [ $ok -eq 1 ]; then
        PASS=$((PASS+1))
        [ -n "${VERBOSE:-}" ] && echo "pass  $name"
    else
        echo "FAIL  $name      ($detail)"
        FAIL=$((FAIL+1)); FAILED_LIST+=("$name")
    fi
}

for manifest in "$ROOT"/examples/*/tests.txt; do
    [ -f "$manifest" ] || continue
    dir="$(basename "$(dirname "$manifest")")"
    if [ -n "$FILTER" ] && [ "$dir" != "$FILTER" ]; then continue; fi

    while read -r name kind expect stdin_data rest; do
        case "$name" in ''|\#*) continue ;; esac
        # shellcheck disable=SC2086
        run_case "$name" "$kind" "$expect" "$stdin_data" $rest
    done < "$manifest"
done

echo "--------------------------------------------------"
echo "passed: $PASS   failed: $FAIL"
if [ "$FAIL" -gt 0 ]; then
    printf 'failing: %s\n' "${FAILED_LIST[*]}"
    exit 1
fi
exit 0
