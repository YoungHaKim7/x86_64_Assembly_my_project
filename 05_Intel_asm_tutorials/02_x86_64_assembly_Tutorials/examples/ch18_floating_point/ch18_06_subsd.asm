; -----------------------------------------------------------------------------
; subsd -- double-precision subtraction
;
; Demonstrates: subsd, cvttsd2si truncation
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_06.lst ch18_06_subsd.asm && ld -g -o ch18_06_subsd ch18_06_subsd.o
; Run:    ./ch18_06_subsd ; echo $?        -> exit code: 10
;
; 10.5 - 0.25 = 10.25 exactly (both powers-of-two fractions).
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dblA        dq  10.5
    dblB        dq  0.25

section .text
global _start
_start:
    movsd   xmm0, qword [dblA]
    subsd   xmm0, qword [dblB]         ; xmm0 = 10.25
    cvttsd2si rax, xmm0                ; 10.25 -> 10

last:
    mov     rdi, rax                    ; exit status = 10
    mov     rax, SYS_exit
    syscall
