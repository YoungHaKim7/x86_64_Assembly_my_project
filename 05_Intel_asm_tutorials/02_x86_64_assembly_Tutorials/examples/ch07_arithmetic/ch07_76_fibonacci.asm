; -----------------------------------------------------------------------------
; Fibonacci (iterative): fib(11) = 89
;
; Demonstrates: addition and register shuffling in a loop -- each term is
;               the sum of the two preceding terms
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_76.lst ch07_76_fibonacci.asm && ld -g -o ch07_76 ch07_76_fibonacci.o
; Run:    ./ch07_76 ; echo $?        -> exit code: 89
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qCount      dq 11                   ; which Fibonacci term to produce

section .text
global _start
_start:

; Sequence: 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89  (11 terms).
; Keep the pair (current, previous); each iteration slides the window:
;   previous <- current,  current <- current + previous.
    mov     rcx, qword [qCount]         ; rcx = 11 (iterations remaining)
    mov     rax, 0                      ; rax = fib(0) = 0 (current)
    mov     rbx, 1                      ; rbx = fib(1) = 1 (previous)

fibLoop:
    mov     rdx, rax                    ; rdx = old current
    add     rax, rbx                    ; current = current + previous
    mov     rbx, rdx                    ; previous = old current
    dec     rcx                         ; one term closer to fib(11)
    jnz     fibLoop                     ; repeat until rcx = 0

; After 11 iterations rax holds fib(11) = 89, rbx holds fib(12) = 144.
    movzx   edi, al                     ; exit status = 89

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (89)
