#!/bin/bash
# -----------------------------------------------------------------------------
# test.sh -- run every example and verify against the chapter tests.txt
#
# Manifest line format (see docs/SPEC.md):
#   <name>  <kind>  <expected>  [stdin|-]  [args...]
# Columns are separated by 2+ spaces or a tab, so <expected> may itself
# contain single spaces. \n inside expected/stdin means newline.
# kinds: exit | out | outc | signal
#   exit   -> $? must equal expected
#   out    -> stdout must equal expected exactly
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
    if [ "$stdin_data" = "-" ] || [ -z "$stdin_data" ]; then
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

# Parse one manifest line into tab-separated: name, kind, expect, stdin, args...
parse_line() {
    awk '
    {
        line = $0
        # name and kind: first two whitespace-delimited tokens
        match(line, /^[[:space:]]*[^[:space:]]+/); name = substr(line, RSTART, RLENGTH)
        line = substr(line, RSTART + RLENGTH)
        match(line, /^[[:space:]]*[^[:space:]]+/); kind = substr(line, RSTART, RLENGTH)
        line = substr(line, RSTART + RLENGTH)
        gsub(/^[[:space:]]+/, "", name); gsub(/^[[:space:]]+/, "", kind)
        sub(/^[[:space:]]+/, "", line)            # leading gap before expect
        sub(/[[:space:]]+$/, "", line)            # trailing gap
        # expect runs until 2+ spaces or a tab
        n = split(line, f, /[[:space:]]{2,}|\t/)
        expect = f[1]; stdin_data = (n >= 2 ? f[2] : "")
        args = ""
        for (i = 3; i <= n; i++) args = args (i > 3 ? " " : "") f[i]
        printf "%s\t%s\t%s\t%s\t%s\n", name, kind, expect, stdin_data, args
    }'
}

for manifest in "$ROOT"/examples/*/tests.txt "$ROOT"/examples/*/*/tests.txt; do
    [ -f "$manifest" ] || continue
    dir="$(basename "$(dirname "$manifest")")"
    if [ -n "$FILTER" ] && [ "$dir" != "$FILTER" ]; then continue; fi

    while IFS=$'\t' read -r name kind expect stdin_data args; do
        case "$name" in ''|\#*) continue ;; esac
        # shellcheck disable=SC2086
        run_case "$name" "$kind" "$expect" "$stdin_data" $args
    done < <(grep -v '^[[:space:]]*#' "$manifest" | grep -v '^[[:space:]]*$' | parse_line)
done

echo "--------------------------------------------------"
echo "passed: $PASS   failed: $FAIL"
if [ "$FAIL" -gt 0 ]; then
    printf 'failing: %s\n' "${FAILED_LIST[*]}"
    exit 1
fi
exit 0
