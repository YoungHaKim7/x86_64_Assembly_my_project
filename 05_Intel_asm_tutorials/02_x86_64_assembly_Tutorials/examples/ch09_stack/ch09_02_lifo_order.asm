; -----------------------------------------------------------------------------
; LIFO order: pushes 1,2,3 come back off the stack as 3,2,1
;
; Demonstrates: last-in first-out ordering of the machine stack
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.1 (Machine Stack)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_02_lifo_order.lst ch09_02_lifo_order.asm && ld -g -o ch09_02_lifo_order ch09_02_lifo_order.o
; Run:    ./ch09_02_lifo_order ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Push a=1, b=2, c=3.  The stack grows DOWN, c sits at the lowest address,
; so the first pop must return c (3), then b (2), then a (1).
    push    1                              ; stack (bottom -> top): 1
    push    2                              ;                          1 2
    push    3                              ;                          1 2 3

    pop     rax                            ; rax = 3 (last in, first out)
    pop     rbx                            ; rbx = 2
    pop     rcx                            ; rcx  = 1 (first in, last out)

; verify the reversed pop order 3, 2, 1 -- exit 1 on success, 0 on failure
    cmp     rax, 3                         ; first pop really c?
    jne     wrongOrder
    cmp     rbx, 2                         ; second pop really b?
    jne     wrongOrder
    cmp     rcx, 1                         ; third pop really a?
    jne     wrongOrder
    mov     rdi, 1                         ; order confirmed
    jmp     last

wrongOrder:
    mov     rdi, 0                         ; LIFO broken (never happens)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
