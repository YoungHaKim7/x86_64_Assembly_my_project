; -----------------------------------------------------------------------------
; xchg: swapping the contents of two registers
;
; Demonstrates: xchg reg64, reg64 — one-instruction register swap
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_07.lst ch07_07_xchg_registers.asm && ld -g -o ch07_07 ch07_07_xchg_registers.o
; Run:    ./ch07_07 ; echo $?        -> exit code: 22
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     rbx, 11                  ; rbx = 11
    mov     rcx, 22                  ; rcx = 22

; xchg exchanges the two operands in a single instruction: afterwards
; each holds what the other used to hold.  Doing this with mov alone
; would need a third "temporary" register and three instructions.
    xchg    rbx, rcx                 ; now rbx = 22 and rcx = 11

; rbx received rcx's old value (22) — that is the swap result we exit with.
last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 22
    syscall
