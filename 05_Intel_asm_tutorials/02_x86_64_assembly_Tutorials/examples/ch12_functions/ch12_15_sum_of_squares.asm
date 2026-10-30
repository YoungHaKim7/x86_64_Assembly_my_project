; -----------------------------------------------------------------------------
; Sum of squares (book-style statistical leaf function)
;
; Demonstrates: loop-based leaf function in the style of the book's
;               statistical examples: one argument in, one statistic in rax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.9 (Example, Statistical
;               Function 1 (leaf))
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_15_sum_of_squares.lst ch12_15_sum_of_squares.asm && ld -g -o ch12_15_sum_of_squares ch12_15_sum_of_squares.o
; Run:    ./ch12_15_sum_of_squares ; echo $?        -> exit code: 91
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; sumSquares -- rdi = n; returns 1*1 + 2*2 + ... + n*n in rax.
; The loop counter lives in callee-saved rbx (pushed/popped here) so no
; caller-saved register has to be spared.
sumSquares:
    push    rbx                         ; preserve rbx for our caller
    push    r12
    mov     r12, rdi                    ; r12 = limit n
    mov     rbx, 1                      ; rbx = i = 1
    xor     rax, rax                    ; rax = running sum = 0
.loop:
    cmp     rbx, r12                    ; i > n ?
    jg      .done
    mov     rdx, rbx
    imul    rdx, rdx                    ; rdx = i * i
    add     rax, rdx                    ; sum += i^2
    inc     rbx                         ; next i
    jmp     .loop
.done:
    pop     r12
    pop     rbx                         ; restore caller's rbx
    ret

_start:
    mov     rdi, 6                      ; n = 6
    call    sumSquares                  ; rax = 1+4+9+16+25+36 = 91

last:
    mov     rdi, rax                    ; exit status = computed result (91)
    mov     rax, SYS_exit               ; call code for exit
    syscall
