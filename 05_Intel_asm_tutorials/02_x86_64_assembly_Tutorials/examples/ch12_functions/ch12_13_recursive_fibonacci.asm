; -----------------------------------------------------------------------------
; Recursive Fibonacci (double recursion)
;
; Demonstrates: a function with TWO recursive calls per activation; n and
;               the first result must both survive the second call, so they
;               are parked in callee-saved registers rbx and r12
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.8.2 (Register Usage),
;               12.8.3 (Call Frame)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_13_recursive_fibonacci.lst ch12_13_recursive_fibonacci.asm && ld -g -o ch12_13_recursive_fibonacci ch12_13_recursive_fibonacci.o
; Run:    ./ch12_13_recursive_fibonacci ; echo $?        -> exit code: 55
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; fib -- rdi = n (n >= 1); returns fib(n) in rax, with
;        fib(1) = fib(2) = 1  (sequence 1, 1, 2, 3, 5, 8, ...).
;
;   fib(n) = fib(n-1) + fib(n-2)
;
; rbx holds n and r12 holds fib(n-1) across the second recursive call; both
; are callee-saved, so each activation pushes and pops them itself.
fib:
    cmp     rdi, 2                      ; base cases: fib(1) = fib(2) = 1
    jbe     .base
    push    rbx                         ; preserve for OUR caller
    push    r12
    mov     rbx, rdi                    ; rbx = n (survives the calls)
    dec     rdi                         ; n-1
    call    fib                         ; rax = fib(n-1)
    mov     r12, rax                    ; r12 = fib(n-1)
    lea     rdi, [rbx - 2]              ; n-2
    call    fib                         ; rax = fib(n-2)
    add     rax, r12                    ; rax = fib(n-1) + fib(n-2)
    pop     r12                         ; restore callee-saved registers
    pop     rbx
    ret
.base:
    mov     rax, 1
    ret

_start:
    mov     rdi, 10                     ; n = 10
    call    fib                         ; rax = fib(10) = 55

last:
    mov     rdi, rax                    ; exit status = computed result (55)
    mov     rax, SYS_exit               ; call code for exit
    syscall
