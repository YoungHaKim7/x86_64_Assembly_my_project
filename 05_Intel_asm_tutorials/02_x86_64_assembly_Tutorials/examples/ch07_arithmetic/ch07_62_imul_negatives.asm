; -----------------------------------------------------------------------------
; imul with negative operands: (-5) * (-5) = +25
;
; Demonstrates: signed multiplication of two negative values
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_62.lst ch07_62_imul_negatives.asm && ld -g -o ch07_62 ch07_62_imul_negatives.o
; Run:    ./ch07_62 ; echo $?        -> exit code: 25
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; imul interprets both operands as signed two's-complement values, so the
; usual sign rules apply: negative times negative yields a positive product.
; (-5 is stored as 0xFFFFFFFFFFFFFFFB, 64-bit two's complement.)
    mov     rax, -5                     ; rax = -5 (signed)
    mov     rbx, -5                     ; rbx = -5 (signed)
    imul    rbx                         ; rdx:rax = (-5) * (-5) = +25

; The 128-bit product is +25: rax = 25 and rdx = 0 (sign bits all clean).
; Had one operand been negative, rdx would have been 0xFFFFFFFFFFFFFFFF.
    movzx   edi, al                     ; exit status = 25

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (25)
