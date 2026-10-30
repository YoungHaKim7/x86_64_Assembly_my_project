#!/bin/bash
# Build project 06: asm main + C helper. $1 = output dir (optional).
#
# helper.c is pure arithmetic (no libc calls), so it is compiled with
# plain 'gcc -c' and linked with ld -- avoiding crt1.o, which would
# install its own _start and demand a C main().
set -e
export PATH="$HOME/asm-tools/usr/bin:$PATH"
cd "$(dirname "$0")"
OUT="${1:-.}"
yasm -f elf64 -g dwarf2 -o main.o main.asm
gcc -c helper.c -o helper.o
ld -g -o "$OUT/proj_06_asm_calls_c" main.o helper.o
rm -f main.o helper.o
