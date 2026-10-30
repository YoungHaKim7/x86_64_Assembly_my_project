; -----------------------------------------------------------------------------
; imul (two operand): imul rbx, rcx -- 13 * 9 = 117
;
; Demonstrates: the two-operand signed multiply, destination * source,
;               single-width truncated result
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_60.lst ch07_60_imul_two_operand.asm && ld -g -o ch07_60 ch07_60_imul_two_operand.o
; Run:    ./ch07_60 ; echo $?        -> exit code: 117
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; The two-operand form computes destination = destination * source.  Unlike
; the one-operand form it produces ONLY the low 64 bits (no rdx:rax pair),
; so it is the convenient choice when the product is known to fit.
    mov     rbx, 13                     ; rbx = 13 (first factor, destination)
    mov     rcx, 9                      ; rcx = 9 (second factor, source)
    imul    rbx, rcx                    ; rbx = 13 * 9 = 117

; rcx is unchanged: only the destination register receives the product.
    movzx   edi, bl                     ; exit status = 117

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (117)
