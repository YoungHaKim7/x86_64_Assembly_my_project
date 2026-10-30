#!/bin/bash
# Build project 02. $1 = output dir (optional).
set -e
export PATH="$HOME/asm-tools/usr/bin:$PATH"
cd "$(dirname "$0")"
OUT="${1:-.}"
yasm -f elf64 -g dwarf2 -o driver.o driver.asm
yasm -f elf64 -g dwarf2 -o lib_minmax.o lib_minmax.asm
yasm -f elf64 -g dwarf2 -o io.o io.asm
ld -g -o "$OUT/proj_02_function_library" driver.o lib_minmax.o io.o
rm -f driver.o lib_minmax.o io.o
