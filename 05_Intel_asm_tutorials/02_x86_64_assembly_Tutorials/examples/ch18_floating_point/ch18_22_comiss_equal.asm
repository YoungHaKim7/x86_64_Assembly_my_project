; -----------------------------------------------------------------------------
; comiss -- equality: (0.5 + 0.5) == 1.0
;
; Demonstrates: computed result compared with a literal
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.6 (Floating-Point Control)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_22.lst ch18_22_comiss_equal.asm && ld -g -o ch18_22_comiss_equal ch18_22_comiss_equal.o
; Run:    ./ch18_22_comiss_equal ; echo $?        -> exit code: 1
;
; Both values are exact in binary, so equality holds bit-for-bit.  For
; results that carry rounding error, compare against an epsilon instead.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltHalf     dd  0.5
    fltOne      dd  1.0

section .text
global _start
_start:
    movss   xmm0, dword [fltHalf]
    addss   xmm0, dword [fltHalf]      ; 0.5 + 0.5
    movss   xmm1, dword [fltOne]
    comiss  xmm0, xmm1
    je      equal
    xor     rax, rax
    jmp     last
equal:
    mov     rax, 1

last:
    mov     rdi, rax                    ; exit status = 1
    mov     rax, SYS_exit
    syscall
