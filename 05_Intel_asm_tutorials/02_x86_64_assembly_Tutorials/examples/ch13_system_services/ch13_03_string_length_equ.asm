; -----------------------------------------------------------------------------
; String length with equ -- $-label computes it at assembly time
;
; Demonstrates: the book's idiom len equ $-msg
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 4.3 and 13.3
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_03.lst ch13_03_string_length_equ.asm && ld -g -o ch13_03_string_length_equ ch13_03_string_length_equ.o
; Run:    ./ch13_03_string_length_equ
;         -> Assembly
;
; '$' is the assembler's current location, so ($-msg) is the number of
; bytes since the label -- the string length without counting by hand.
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1

section .data
    msg         db  "Assembly", 10
    msgLen      equ $-msg              ; 9: 8 letters + newline

section .text
global _start
_start:
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, msg
    mov     rdx, msgLen                ; length came from equ
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
