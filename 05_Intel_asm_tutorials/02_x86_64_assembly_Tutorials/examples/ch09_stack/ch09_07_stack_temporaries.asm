; -----------------------------------------------------------------------------
; stack temporaries: (10+20)*(3-1) = 60 with intermediates kept on the stack
;
; Demonstrates: spilling intermediate results to the stack between steps
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.3 (Stack Local Variables)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_07_stack_temporaries.lst ch09_07_stack_temporaries.asm && ld -g -o ch09_07_stack_temporaries ch09_07_stack_temporaries.o
; Run:    ./ch09_07_stack_temporaries ; echo $?        -> exit code: 60
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Evaluate (10+20)*(3-1) using the stack as a scratchpad for the two
; sub-results, the way a compiler spills temporaries.
    mov     rax, 10                        ; left operand
    add     rax, 20                        ; rax = 30  (10+20)
    push    rax                            ; temp A = 30 on the stack

    mov     rbx, 3                         ; right operand
    sub     rbx, 1                         ; rbx = 2   (3-1)
    push    rbx                            ; temp B = 2 on the stack

; pops come back in reverse order: B first, then A
    pop     rbx                            ; rbx = 2
    pop     rax                            ; rax = 30
    imul    rax, rbx                       ; rax = 30 * 2 = 60

    mov     rdi, rax                       ; exit code = 60

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
