#!/bin/bash
# Build project 05: C main + assembly function. $1 = output dir (optional).
set -e
export PATH="$HOME/asm-tools/usr/bin:$PATH"
cd "$(dirname "$0")"
OUT="${1:-.}"
yasm -f elf64 -g dwarf2 -o power.o power.asm
gcc -no-pie main.c power.o -o "$OUT/proj_05_c_calls_asm"
rm -f power.o
