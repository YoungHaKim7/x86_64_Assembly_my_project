; -----------------------------------------------------------------------------
; Primality test by trial division
;
; Demonstrates: a predicate function returning a boolean in rax (1 = prime,
;               0 = composite), loop state kept in callee-saved registers,
;               early exit on the first divisor found
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.5 (Standard Calling Convention),
;               12.8.2 (Register Usage)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_23_is_prime_function.lst ch12_23_is_prime_function.asm && ld -g -o ch12_23_is_prime_function ch12_23_is_prime_function.o
; Run:    ./ch12_23_is_prime_function ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; isPrime -- rdi = n (n >= 2); returns 1 in rax if n is prime, else 0.
;
; Trial division: test candidate divisors d = 2, 3, ... while d*d <= n.
; No divisor up to sqrt(n) -> n is prime. n lives in rbx and d in r12,
; both callee-saved (pushed and popped here).
isPrime:
    push    rbx
    push    r12
    mov     rbx, rdi                    ; rbx = n
    mov     r12, 2                      ; r12 = trial divisor d
.trial:
    mov     rax, r12
    imul    rax, r12                    ; rax = d*d
    cmp     rax, rbx                    ; d*d > n -> no divisor exists
    jg      .prime
    mov     rax, rbx
    xor     rdx, rdx                    ; rdx = 0 before unsigned division
    div     r12                         ; rdx = n mod d
    test    rdx, rdx                    ; divides evenly?
    jz      .composite
    inc     r12                         ; next candidate divisor
    jmp     .trial
.prime:
    mov     rax, 1                      ; boolean true
    jmp     .done
.composite:
    xor     rax, rax                    ; boolean false
.done:
    pop     r12
    pop     rbx
    ret

_start:
    mov     rdi, 89                     ; n = 89 (prime)
    call    isPrime                     ; rax = 1

last:
    mov     rdi, rax                    ; exit status = 1 (prime)
    mov     rax, SYS_exit               ; call code for exit
    syscall
