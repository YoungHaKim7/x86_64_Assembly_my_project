#!/bin/bash
# Build project 04. $1 = output dir (optional).
set -e
export PATH="$HOME/asm-tools/usr/bin:$PATH"
cd "$(dirname "$0")"
OUT="${1:-.}"
yasm -f elf64 -g dwarf2 -o main.o main.asm
yasm -f elf64 -g dwarf2 -o strlen.o strlen.asm
yasm -f elf64 -g dwarf2 -o upper.o upper.asm
yasm -f elf64 -g dwarf2 -o count.o count.asm
yasm -f elf64 -g dwarf2 -o io.o io.asm
ld -g -o "$OUT/proj_04_string_utils" main.o strlen.o upper.o count.o io.o
rm -f main.o strlen.o upper.o count.o io.o
