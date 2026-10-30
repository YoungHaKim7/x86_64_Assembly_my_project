; -----------------------------------------------------------------------------
; Loading constants: mov immediate into a register
;
; Demonstrates: mov reg64, imm64 — immediate (constant) to register moves
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_01.lst ch07_01_mov_imm_to_reg.asm && ld -g -o ch07_01 ch07_01_mov_imm_to_reg.o
; Run:    ./ch07_01 ; echo $?        -> exit code: 77
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; The simplest data movement loads a constant (an "immediate" operand)
; into a register.  The destination register is on the left, the source
; constant on the right, and mov never modifies its source.
    mov     rbx, 77                  ; rbx = 77 (quadword immediate)
    mov     rcx, 21                  ; rcx = 21
    mov     rdx, 13                  ; rdx = 13
    mov     rsi, 5                   ; rsi = 5

; Each mov above wrote only its own destination, so rbx still holds 77
; even after the three mov instructions that followed it.

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 77
    syscall
