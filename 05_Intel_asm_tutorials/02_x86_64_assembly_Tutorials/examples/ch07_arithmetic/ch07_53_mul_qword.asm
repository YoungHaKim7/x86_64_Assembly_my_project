; -----------------------------------------------------------------------------
; mul (one operand, quadword): 12 * 11 = 132
;
; Demonstrates: unsigned quadword multiply mul, 128-bit product in rdx:rax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_53.lst ch07_53_mul_qword.asm && ld -g -o ch07_53 ch07_53_mul_qword.o
; Run:    ./ch07_53 ; echo $?        -> exit code: 132
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVal1       dq 12                   ; first factor (multiplicand)
    qVal2       dq 11                   ; second factor (multiplier)

section .bss
    qProduct    resq 2                  ; room for the full 128-bit product

section .text
global _start
_start:

; The one-operand form of mul multiplies rax by the operand.  The full
; 128-bit unsigned product is placed in rdx:rax:  high 64 bits in rdx,
; low 64 bits in rax.  rdx is always overwritten, even for small products.
    mov     rax, qword [qVal1]          ; rax = 12 (multiplicand)
    mov     rbx, qword [qVal2]          ; rbx = 11 (multiplier)
    mul     rbx                         ; rdx:rax = 12 * 11 = 132

    mov     qword [qProduct], rax       ; store low 64 bits of product (132)
    mov     qword [qProduct+8], rdx     ; store high 64 bits of product (0)

; Product 132 is far below 2^64, so the high half rdx = 0: no unsigned
; overflow occurred.  Exit with the product itself (132 fits in a byte).
last:
    mov     rax, SYS_exit               ; call code for exit
    mov     rdi, qword [qProduct]       ; exit status = product (132)
    syscall
