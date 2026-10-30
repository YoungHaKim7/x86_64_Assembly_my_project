; -----------------------------------------------------------------------------
; Standard error -- fd 2 is a separate output stream
;
; Demonstrates: writing to STDOUT (fd 1) and STDERR (fd 2)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.3 (Console Output)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_24.lst ch13_24_stderr_write.asm && ld -g -o ch13_24_stderr_write ch13_24_stderr_write.o
; Run:    ./ch13_24_stderr_write
;         -> to stdout    (on stdout)
;            to stderr    (on stderr -- redirect with 2>file to see it apart)
;
; Both are usually the terminal, but they can be redirected separately:
; diagnostics belong on stderr so they never pollute program output.
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
STDERR           equ 2

section .data
    outMsg      db  "to stdout", 10
    outLen      equ $-outMsg
    errMsg      db  "to stderr", 10
    errLen      equ $-errMsg

section .text
global _start
_start:
    mov     rax, SYS_write
    mov     rdi, STDOUT                ; fd 1
    mov     rsi, outMsg
    mov     rdx, outLen
    syscall

    mov     rax, SYS_write
    mov     rdi, STDERR                ; fd 2: same call, different stream
    mov     rsi, errMsg
    mov     rdx, errLen
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
