; -----------------------------------------------------------------------------
; sqrtsd -- square root, double precision
;
; Demonstrates: sqrtsd
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_10.lst ch18_10_sqrtsd.asm && ld -g -o ch18_10_sqrtsd ch18_10_sqrtsd.o
; Run:    ./ch18_10_sqrtsd ; echo $?        -> exit code: 1
;
; sqrt(2.25) = 1.5 exactly; truncation gives 1.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dblA        dq  2.25

section .text
global _start
_start:
    sqrtsd  xmm0, qword [dblA]         ; xmm0 = 1.5
    cvttsd2si rax, xmm0                ; 1

last:
    mov     rdi, rax                    ; exit status = 1
    mov     rax, SYS_exit
    syscall
