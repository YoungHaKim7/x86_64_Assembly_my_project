; -----------------------------------------------------------------------------
; sbb: 128-bit subtraction that needs no borrow (100 - 1)
;
; Demonstrates: multi-precision subtraction where CF is 0, so sbb adds nothing
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_42_sub_128bit_small.lst ch07_42_sub_128bit_small.asm && ld -g -o ch07_42_sub_128bit_small ch07_42_sub_128bit_small.o
; Run:    ./ch07_42_sub_128bit_small ; echo $?        -> exit code: 99
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; 128-bit value 100 held as rdx:rax = 0:100 (high qword is zero)
    mov     rdx, 0                         ; high qword
    mov     rax, 100                       ; low qword

; subtract 1: entirely inside the low qword, no borrow occurs
    sub     rax, 1                         ; rax = 99, CF = 0 (no borrow)
    sbb     rdx, 0                         ; rdx = 0 - 0 - 0 = 0 (unchanged)

; full 128-bit result: 0x0000000000000000_0000000000000063 (99)
; this is the boring but common case: sbb keeps the high half correct
; whether or not the low sub borrowed
    mov     rdi, rax                       ; exit = low qword = 99

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
