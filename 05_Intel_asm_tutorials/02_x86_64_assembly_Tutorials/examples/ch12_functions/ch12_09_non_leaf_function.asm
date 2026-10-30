; -----------------------------------------------------------------------------
; Non-leaf function: a function that calls another function
;
; Demonstrates: call chains, keeping a value alive across an inner call by
;               parking it in a callee-saved register
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.10 (Example, Statistical Function 2
;               (non-leaf)), 12.8.2 (Register Usage)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_09_non_leaf_function.lst ch12_09_non_leaf_function.asm && ld -g -o ch12_09_non_leaf_function ch12_09_non_leaf_function.o
; Run:    ./ch12_09_non_leaf_function ; echo $?        -> exit code: 30
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; doubleArg -- leaf function: returns 2 * rdi in rax.
doubleArg:
    mov     rax, rdi                    ; rax = n
    add     rax, rax                    ; rax = 2n
    ret

; -----------------------------------------------------------------------------
; tripleArg -- non-leaf function: returns doubleArg(n) + n (= 3n) in rax.
; The argument n must survive the inner call. rdi is caller-saved, so n is
; parked in callee-saved rbx (pushed and popped here, since this function
; itself must preserve rbx for ITS caller).
tripleArg:
    push    rbx                         ; preserve rbx for our caller
    mov     rbx, rdi                    ; rbx = n, safe across the call
    call    doubleArg                   ; rax = 2n
    add     rax, rbx                    ; rax = 2n + n = 3n
    pop     rbx                         ; restore caller's rbx
    ret

_start:
    mov     rdi, 10                     ; n = 10
    call    tripleArg                   ; rax = doubleArg(10) + 10 = 30

last:
    mov     rdi, rax                    ; exit status = computed result (30)
    mov     rax, SYS_exit               ; call code for exit
    syscall
