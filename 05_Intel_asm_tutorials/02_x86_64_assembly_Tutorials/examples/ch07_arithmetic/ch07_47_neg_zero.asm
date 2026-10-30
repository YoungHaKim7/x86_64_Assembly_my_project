; -----------------------------------------------------------------------------
; neg: negating zero leaves zero and sets ZF
;
; Demonstrates: neg of zero, zero flag (ZF), jz (jump if zero)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_47_neg_zero.lst ch07_47_neg_zero.asm && ld -g -o ch07_47_neg_zero ch07_47_neg_zero.o
; Run:    ./ch07_47_neg_zero ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; neg computes 0 - operand; when the operand itself is 0 the result is 0
; and the CPU reports that with ZF = 1
    mov     rax, 0                        ; rax = 0
    neg     rax                           ; rax = 0 - 0 = 0, ZF = 1
    jz      zeroResult                    ; ZF set -> negation produced zero

    mov     rdi, EXIT_SUCCESS             ; exit code 0: nonzero result
    jmp     last

zeroResult:
    mov     rdi, 1                        ; exit code 1: zero detected via ZF

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
