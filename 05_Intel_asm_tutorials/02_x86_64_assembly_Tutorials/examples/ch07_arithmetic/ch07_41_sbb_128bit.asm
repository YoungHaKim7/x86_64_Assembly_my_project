; -----------------------------------------------------------------------------
; sbb: 128-bit subtraction (2^64 - 1) with borrow propagation
;
; Demonstrates: multi-precision subtraction using sub (low) and sbb (high)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_41_sbb_128bit.lst ch07_41_sbb_128bit.asm && ld -g -o ch07_41_sbb_128bit ch07_41_sbb_128bit.o
; Run:    ./ch07_41_sbb_128bit ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; 128-bit value 2^64 held as rdx:rax = 0x0000000000000001:0x0000000000000000
    mov     rdx, 1                         ; high qword
    mov     rax, 0                         ; low qword

; subtract 1: the low qword cannot hold -1, so sub borrows from the high
    sub     rax, 1                         ; 0 - 1 -> rax = 0xFFFFFFFFFFFFFFFF,
                                            ;          CF = 1 (borrow needed)
    sbb     rdx, 0                         ; high: 1 - 0 - CF = 0

; full 128-bit result: 0x0000000000000000_FFFFFFFFFFFFFFFF
; (2^64 - 1 = 18446744073709551615, the borrow collapsed the high qword)
    mov     rdi, rax                       ; exit = low qword & 0xFF = 255

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
