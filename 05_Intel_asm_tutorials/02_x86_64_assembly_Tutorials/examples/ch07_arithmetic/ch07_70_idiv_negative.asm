; -----------------------------------------------------------------------------
; idiv (negative dividend): -137 / 10 -> quotient -13, remainder -7
;
; Demonstrates: x86 signed division truncates toward zero, so the remainder
;               carries the sign of the dividend
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_70.lst ch07_70_idiv_negative.asm && ld -g -o ch07_70 ch07_70_idiv_negative.o
; Run:    ./ch07_70 ; echo $?        -> exit code: 249
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; idiv truncates the quotient TOWARD ZERO (it does not floor).  For
; -137 / 10 that gives q = -13 (not -14), and the remainder is defined by
; dividend = divisor * quotient + remainder, so r = -137 - 10*(-13) = -7.
    mov     rax, -137                   ; rax = -137 (signed dividend)
    cqo                                ; rdx = 0xFFFFFFFFFFFFFFFF (sign bits)
    mov     rbx, 10                     ; rbx = 10 (positive divisor)
    idiv    rbx                         ; rax = -13, rdx = -7

; The remainder -7 sits in rdx as 0xFFFFFFF9 (low byte 0xF9).  The exit
; status keeps the low 8 bits, so the shell reports 0xF9 = 249 decimal.
    movzx   edi, dl                     ; exit status = 249 (low byte of -7)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (249)
