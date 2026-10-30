#!/bin/bash
# Build project 03. $1 = output dir (optional).
set -e
export PATH="$HOME/asm-tools/usr/bin:$PATH"
cd "$(dirname "$0")"
OUT="${1:-.}"
yasm -f elf64 -g dwarf2 -o main.o main.asm
yasm -f elf64 -g dwarf2 -o helper.o helper.asm
ld -g -o "$OUT/proj_03_extern_global" main.o helper.o
rm -f main.o helper.o
