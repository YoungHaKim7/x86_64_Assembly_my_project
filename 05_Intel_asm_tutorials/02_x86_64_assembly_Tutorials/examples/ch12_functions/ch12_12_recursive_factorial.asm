; -----------------------------------------------------------------------------
; Recursive factorial
;
; Demonstrates: recursion with the standard calling convention: each active
;               invocation keeps its own n on the stack, rax carries the
;               partial product back up the chain
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.8.3 (Call Frame),
;               12.10 (Example, Statistical Function 2 (non-leaf))
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_12_recursive_factorial.lst ch12_12_recursive_factorial.asm && ld -g -o ch12_12_recursive_factorial ch12_12_recursive_factorial.o
; Run:    ./ch12_12_recursive_factorial ; echo $?        -> exit code: 120
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; fact -- rdi = n (n >= 0); returns n! in rax.
;
;   fact(n) = n * fact(n-1),   fact(0) = 1
;
; Stack discipline: each non-base call pushes its own n before recursing,
; so every activation has a private copy; pop restores it exactly one frame
; up. rdi is caller-saved, so no callee-saved register is needed at all.
fact:
    cmp     rdi, 1                      ; base case: n <= 1
    jle     .base
    push    rdi                         ; save THIS frame's n
    dec     rdi                         ; argument n-1
    call    fact                        ; rax = (n-1)!
    pop     rdi                         ; restore THIS frame's n
    imul    rax, rdi                    ; rax = n * (n-1)!
    ret
.base:
    mov     rax, 1                      ; 0! = 1! = 1
    ret

_start:
    mov     rdi, 5                      ; n = 5
    call    fact                        ; rax = 5! = 120

last:
    mov     rdi, rax                    ; exit status = computed result (120)
    mov     rax, SYS_exit               ; call code for exit
    syscall
