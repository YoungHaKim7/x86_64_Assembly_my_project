; -----------------------------------------------------------------------------
; stack sum: push {1,2,3,4,5} then accumulate the values while popping
;
; Demonstrates: folding a list through the stack with add
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.2 (Stack Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_11_stack_sum.lst ch09_11_stack_sum.asm && ld -g -o ch09_11_stack_sum ch09_11_stack_sum.o
; Run:    ./ch09_11_stack_sum ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 1, 2, 3, 4, 5           ; list to sum
    LEN         equ 5                      ; number of elements

section .text
global _start
_start:

; Load the whole list onto the stack first.
    mov     r12, 0                         ; i = 0
    mov     rcx, LEN                       ; rcx = element count (for loop)
pushLoop:
    push    qword [qArr + r12*8]           ; push qArr[i]
    inc     r12                            ; i++
    loop    pushLoop                       ; dec rcx; repeat while rcx > 0

; Drain the stack, adding each popped qword to a running sum.
; 1 + 2 + 3 + 4 + 5 = 15
    mov     rbx, 0                         ; sum = 0
    mov     rcx, LEN                       ; rcx = element count (for loop)
popLoop:
    pop     rax                            ; rax = next stack element
    add     rbx, rax                       ; sum += rax
    loop    popLoop                        ; dec rcx; repeat while rcx > 0

    mov     rdi, rbx                       ; exit code = 15

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
