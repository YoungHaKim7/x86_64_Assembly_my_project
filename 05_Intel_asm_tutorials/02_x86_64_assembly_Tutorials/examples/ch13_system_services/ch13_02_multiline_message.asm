; -----------------------------------------------------------------------------
; Multiline output -- three separate write calls
;
; Demonstrates: several SYS_write calls in sequence
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 13.3 (Console Output)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_02.lst ch13_02_multiline_message.asm && ld -g -o ch13_02_multiline_message ch13_02_multiline_message.o
; Run:    ./ch13_02_multiline_message
;         -> one
;            two
;            three
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1

section .data
    line1       db  "one", 10
    len1        equ $-line1
    line2       db  "two", 10
    len2        equ $-line2
    line3       db  "three", 10
    len3        equ $-line3

section .text
global _start
_start:
    mov     rax, SYS_write             ; first line
    mov     rdi, STDOUT
    mov     rsi, line1
    mov     rdx, len1
    syscall

    mov     rax, SYS_write             ; second line
    mov     rdi, STDOUT
    mov     rsi, line2
    mov     rdx, len2
    syscall

    mov     rax, SYS_write             ; third line
    mov     rdi, STDOUT
    mov     rsi, line3
    mov     rdx, len3
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
