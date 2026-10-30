; -----------------------------------------------------------------------------
; Leaf function: call and ret
;
; Demonstrates: call/ret instruction pair, leaf function (calls nothing),
;               argument in rdi, return value in rax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.5 (Standard Calling Convention),
;               12.8.2 (Register Usage)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_01_leaf_function.lst ch12_01_leaf_function.asm && ld -g -o ch12_01_leaf_function ch12_01_leaf_function.o
; Run:    ./ch12_01_leaf_function ; echo $?        -> exit code: 40
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; doubleIt -- leaf function: returns 2 * rdi in rax.
; A leaf function calls no other function, so it needs no stack frame and
; touches no callee-saved register: ret finds the return address right where
; call left it, on top of the stack.
doubleIt:
    mov     rax, rdi                    ; rax = first (and only) argument
    add     rax, rax                    ; rax = 2 * rdi
    ret                                 ; return to caller, result in rax

_start:
    mov     rdi, 20                     ; argument: 20
    call    doubleIt                    ; rax = 40

last:
    mov     rdi, rax                    ; exit status = computed result (40)
    mov     rax, SYS_exit               ; call code for exit
    syscall
