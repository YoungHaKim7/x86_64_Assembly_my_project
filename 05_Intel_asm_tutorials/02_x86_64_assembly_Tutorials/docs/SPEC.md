# Example Program Specification

All examples in this collection follow the conventions of
*"x86-64 Assembly Language Programming with Ubuntu"* (Ed Jorgensen, v1.1.40),
which uses the **YASM assembler (NASM syntax)**, ELF64, and raw Linux syscalls
(no libc) linked with `ld`.

## Toolchain (already installed, no sudo needed)

```
export PATH="$HOME/asm-tools/usr/bin:$PATH"     # yasm 1.3.0 + nasm 3.01

yasm -f elf64 -g dwarf2 -l file.lst file.asm    # assemble
ld -g -o file file.o                            # link
./file ; echo $?                                # run
```

Every program MUST assemble with `yasm -f elf64` and link with plain `ld`
(no gcc, no libc) unless the example explicitly involves C interop.

## Mandatory file template

```asm
; -----------------------------------------------------------------------------
; <one-line title>
;
; Demonstrates: <instruction(s)/concept shown>
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section <x.y>
;
; Build:  yasm -f elf64 -g dwarf2 -l chNN_MM.lst chNN_MM.asm && ld -g -o chNN_MM chNN_MM.o
; Run:    ./chNN_MM ; echo $?        -> exit code: <N>
; -----------------------------------------------------------------------------

SYS_exit         equ 60            ; and other SYS_* constants used
EXIT_SUCCESS     equ 0

section .data                          ; omit if unused
    <vars>

section .bss                           ; omit if unused
    <vars>

section .text
global _start
_start:
    <code>

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS          ; or the computed result
    syscall
```

Rules:
- 4-space indentation inside `_start:`, one instruction per line,
  operands aligned in one column where practical.
- Standard constant names from the book:
  `SYS_read equ 0`, `SYS_write equ 1`, `SYS_open equ 2`, `SYS_close equ 3`,
  `SYS_fork equ 57`, `SYS_exit equ 60`, `SYS_wait4 equ 61`,
  `SYS_nanosleep equ 35`, `SYS_unlink equ 87`, `SYS_getpid equ 39`,
  `STDOUT equ 1`, `STDERR equ 2`, `O_RDONLY equ 0`, `O_WRONLY equ 1`,
  `O_CREAT equ 64`, `O_APPEND equ 1024`, `NL equ 10`.
- Variable naming from the book: `bVar`, `wVar`, `dVar`, `qVar`, `bArr`,
  `wArr`, `dArr`, `qArr`, `flt1`, `dbl1`, `strng` — with sizes always made
  explicit in memory operands: `mov al, byte [bVar1]`,
  `mov eax, dword [dVar1]`, `mov rax, qword [qVar1]`.
- Comment *why/what*, one short comment per logical step. No dead code.
- Result values are chosen so the exit code is in **0..255**
  (the shell only keeps the low 8 bits of the exit status).

## Verification & manifests

Every example must be assembled, linked, RUN, and its actual output recorded
by the authoring agent. Each chapter directory contains a `tests.txt`
manifest consumed by `scripts/test.sh`. One line per example:

```
# <name>            <kind>   <expected>        [<stdin>]   [<args...>]
ch03_01_xxx          exit     251
ch13_06_yyy          exit     5                 hello\n
ch13_02_yyy          out      Hello World\n
ch13_09_yyy          outc     12345
ch20_01_zzz          signal   8
ch16_01_aaa          exit     4                 -           x  y  z
```

Fields are separated by whitespace; a literal `\n` inside the stdin field
means newline; use `-` as an explicit empty placeholder so the field count
is unambiguous (stdin `-` = no input; args absent = none).

Kinds:
- `exit`    — program's $? must equal *expected*
- `out`     — program's stdout must equal *expected* exactly, including any
  trailing newline (written in the manifest as text ending in `\n`)
- `outc`    — stdout must contain *expected* as a substring
- `signal`  — program must die from signal *expected* (e.g. 8 = SIGFPE)
- stdin field is piped to the program (`printf '%b'` semantics)
- args fields are passed as command-line arguments

Manifest lines starting with `#` are comments. Blank lines ignored.
The `<name>` is the program's basename without `.asm` (for multi-file
projects: the executable's name; its build.sh must produce it).

## Output-printing examples (ch13+)

Programs that print use `SYS_write` with `STDOUT`. Integer printing is done
with the book's itoa algorithm (divide by 10, push remainders, pop to buffer).
Integer parsing (atoi) uses the book's algorithm (multiply by 10, add digit).

## What NOT to do

- No libc calls (`printf`, `malloc`), no `extern` to C — EXCEPT the dedicated
  C-interop projects in `ch14_multi_source/` which use `gcc -no-pie`.
- No AT&T syntax, no GNU-as directives.
- Do not invent syscalls; numbers above are the x86-64 Linux ABI.
- Values that would truncate confusingly in an exit code: pick inputs so the
  interesting result fits in 0..255, and put the full result in comments.
- No infinite loops; every program terminates.
