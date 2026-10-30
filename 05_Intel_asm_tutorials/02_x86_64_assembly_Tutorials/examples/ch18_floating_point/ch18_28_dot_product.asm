; -----------------------------------------------------------------------------
; Dot product -- sum of a[i]*b[i] over two double arrays
;
; Demonstrates: paired array traversal with mulsd/addsd
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_28.lst ch18_28_dot_product.asm && ld -g -o ch18_28_dot_product ch18_28_dot_product.o
; Run:    ./ch18_28_dot_product ; echo $?        -> exit code: 32
;
; {1,2,3} . {4,5,6} = 1*4 + 2*5 + 3*6 = 4+10+18 = 32.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    vecA        dq  1.0, 2.0, 3.0
    vecB        dq  4.0, 5.0, 6.0
    vecLen      equ 3

section .text
global _start
_start:
    xorps   xmm0, xmm0                 ; accumulator
    mov     rsi, vecA
    mov     rdx, vecB
    mov     rcx, vecLen

.dotLoop:
    test    rcx, rcx
    jz      .done
    movsd   xmm1, qword [rsi]
    mulsd   xmm1, qword [rdx]          ; a[i] * b[i]
    addsd   xmm0, xmm1                 ; accumulate
    add     rsi, 8
    add     rdx, 8
    dec     rcx
    jmp     .dotLoop
.done:
    cvttsd2si rax, xmm0                ; 32

last:
    mov     rdi, rax                    ; exit status = 32
    mov     rax, SYS_exit
    syscall
