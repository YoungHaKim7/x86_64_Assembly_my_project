#!/bin/bash
# Build project 01: three objects, one link. $1 = output dir (optional).
set -e
export PATH="$HOME/asm-tools/usr/bin:$PATH"
cd "$(dirname "$0")"
OUT="${1:-.}"
yasm -f elf64 -g dwarf2 -o main.o main.asm
yasm -f elf64 -g dwarf2 -o sum.o sum.asm
yasm -f elf64 -g dwarf2 -o io.o io.asm
ld -g -o "$OUT/proj_01_sum_average" main.o sum.o io.o
rm -f main.o sum.o io.o
