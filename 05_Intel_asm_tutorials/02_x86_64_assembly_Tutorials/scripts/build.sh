#!/bin/bash
# -----------------------------------------------------------------------------
# build.sh -- assemble + link every example in examples/
#
# Usage:
#   scripts/build.sh               build everything
#   scripts/build.sh ch07_arithmetic   build only that chapter directory
#
# Executables land in bin/ at the collection root, one per .asm file.
# Multi-file projects (ch14_multi_source) are built by their own build.sh.
# -----------------------------------------------------------------------------
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export PATH="$HOME/asm-tools/usr/bin:$PATH"      # yasm lives here if not system-wide

if ! command -v yasm >/dev/null 2>&1; then
    echo "error: yasm not found. Install it, or run:"
    echo "  mkdir -p ~/asm-tools && cd ~/asm-tools"
    echo "  apt-get download yasm && dpkg -x yasm_*.deb ~/asm-tools"
    exit 1
fi

BIN="$ROOT/bin"
mkdir -p "$BIN"

FILTER="${1:-}"
BUILT=0
FAILED=0

# ---- single-file examples ----------------------------------------------------
for src in "$ROOT"/examples/*/*.asm; do
    [ -f "$src" ] || continue
    dir="$(basename "$(dirname "$src")")"
    if [ -n "$FILTER" ] && [ "$dir" != "$FILTER" ]; then continue; fi

    name="$(basename "$src" .asm)"
    srcdir="$(dirname "$src")"

    if yasm -f elf64 -g dwarf2 -I "$srcdir/" -o "$BIN/$name.o" "$src" 2> "$BIN/$name.err" \
       && ld -g -o "$BIN/$name" "$BIN/$name.o" 2>> "$BIN/$name.err"; then
        BUILT=$((BUILT+1))
        rm -f "$BIN/$name.err"
    else
        echo "BUILD FAILED: $dir/$name"
        sed 's/^/    /' "$BIN/$name.err"
        FAILED=$((FAILED+1))
    fi
    rm -f "$BIN/$name.o"
done

# ---- multi-file projects -----------------------------------------------------
for proj in "$ROOT"/examples/ch14_multi_source/*/; do
    [ -f "$proj/build.sh" ] || continue
    pdir="$(basename "$proj")"
    if [ -n "$FILTER" ] && [ "ch14_multi_source" != "$FILTER" ]; then continue; fi
    if ( cd "$proj" && bash build.sh "$BIN" >/dev/null 2>&1 ); then
        BUILT=$((BUILT+1))
    else
        echo "BUILD FAILED: ch14_multi_source/$pdir (run its build.sh to see errors)"
        FAILED=$((FAILED+1))
    fi
done

echo "--------------------------------------------------"
echo "built: $BUILT   failed: $FAILED   (binaries in $BIN)"
[ "$FAILED" -eq 0 ]
