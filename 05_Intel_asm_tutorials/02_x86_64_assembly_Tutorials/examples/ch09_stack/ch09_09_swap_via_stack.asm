; -----------------------------------------------------------------------------
; swap via the stack: exchange a=4 and b=9 stored in memory
;
; Demonstrates: LIFO ordering turned into a two-variable swap
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.2 (Stack Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_09_swap_via_stack.lst ch09_09_swap_via_stack.asm && ld -g -o ch09_09_swap_via_stack ch09_09_swap_via_stack.o
; Run:    ./ch09_09_swap_via_stack ; echo $?        -> exit code: 4
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVarA       dq 4                       ; a = 4
    qVarB       dq 9                       ; b = 9

section .text
global _start
_start:

; Push a, then b.  Popping yields b first and a second, so the first pop
; lands in A's slot and the second in B's slot: a and b trade places
; without needing a third variable.
    push    qword [qVarA]                  ; stack: [a=4]
    push    qword [qVarB]                  ; stack: [a=4, b=9]

    pop     rax                            ; rax = 9 (was b)
    mov     qword [qVarA], rax             ; a = 9
    pop     rax                            ; rax = 4 (was a)
    mov     qword [qVarB], rax             ; b = 4

    mov     rdi, qword [qVarB]             ; exit code = b = 4

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
