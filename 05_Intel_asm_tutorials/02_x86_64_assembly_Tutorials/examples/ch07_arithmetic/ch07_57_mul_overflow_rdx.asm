; -----------------------------------------------------------------------------
; mul overflow detection: 2^40 * 2^30 -> rdx != 0 means result overflows 64 bits
;
; Demonstrates: using the high half rdx after quadword mul as an unsigned
;               overflow indicator
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_57.lst ch07_57_mul_overflow_rdx.asm && ld -g -o ch07_57 ch07_57_mul_overflow_rdx.o
; Run:    ./ch07_57 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVal1       dq 0x10000000000        ; 2^40
    qVal2       dq 0x40000000           ; 2^30

section .text
global _start
_start:

; mul does not trap on overflow -- it silently produces a 128-bit product
; in rdx:rax.  The standard unsigned-overflow check for the quadword form:
; after the multiply, a NON-ZERO rdx means the true product does not fit
; in 64 bits (rax alone holds only the low half).
    mov     rax, qword [qVal1]          ; rax = 2^40
    mov     rbx, qword [qVal2]          ; rbx = 2^30
    mul     rbx                         ; rdx:rax = 2^70

; 2^70 >> 64 = 2^6 = 64, so rdx = 64 (non-zero): overflow detected.
    mov     edi, EXIT_SUCCESS           ; assume no overflow (status 0)
    cmp     rdx, 0                      ; high half of product zero?
    je      last                        ; yes: product fits in rax alone

    mov     edi, 1                      ; no: rdx != 0 -> unsigned overflow

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1 = overflow seen)
