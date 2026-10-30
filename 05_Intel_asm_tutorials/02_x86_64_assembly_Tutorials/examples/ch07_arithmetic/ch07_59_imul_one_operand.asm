; -----------------------------------------------------------------------------
; imul (one operand, quadword): -6 * 7 = -42 (signed)
;
; Demonstrates: signed multiply imul, two's-complement product, exit status
;               keeping only the low 8 bits
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_59.lst ch07_59_imul_one_operand.asm && ld -g -o ch07_59 ch07_59_imul_one_operand.o
; Run:    ./ch07_59 ; echo $?        -> exit code: 214
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Like mul, the one-operand imul multiplies rax by the operand and writes
; the double-width product to rdx:rax -- but it treats both inputs and the
; result as SIGNED two's-complement values.
    mov     rax, -6                     ; rax = -6 (signed multiplicand)
    mov     rbx, 7                      ; rbx = 7 (signed multiplier)
    imul    rbx                         ; rdx:rax = -6 * 7 = -42

; -42 in 64-bit two's complement is 0xFFFFFFFFFFFFFFD6.  The exit status
; keeps only the low 8 bits, so the shell reports 0xD6 = 214 decimal.
; The comment trail, not the status, carries the signed meaning (-42).
    movzx   edi, al                     ; edi = 0xD6 = 214 (low byte of -42)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (214)
