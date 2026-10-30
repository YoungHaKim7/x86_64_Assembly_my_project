; -----------------------------------------------------------------------------
; neg: negate a qword (-100 -> 100)
;
; Demonstrates: neg instruction with a 64-bit operand
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_46_neg_qword.lst ch07_46_neg_qword.asm && ld -g -o ch07_46_neg_qword ch07_46_neg_qword.o
; Run:    ./ch07_46_neg_qword ; echo $?        -> exit code: 100
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar1       dq -100                   ; negative qword operand

section .bss
    qResult     resq 1                    ; room for the qword result

section .text
global _start
_start:

; neg qVar1 computes 0 - (-100) = +100. In two's complement the bits of
; -100 (0xFFFFFFFFFFFFFF9C) flip to exactly those of +100 (0x64)
    mov     rax, qword [qVar1]            ; rax = -100
    neg     rax                           ; rax = 100
    mov     qword [qResult], rax          ; store the full 64-bit result

; SF clears (positive result); 100 fits the exit-code range directly
    mov     rdi, qword [qResult]          ; rdi = 100

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
