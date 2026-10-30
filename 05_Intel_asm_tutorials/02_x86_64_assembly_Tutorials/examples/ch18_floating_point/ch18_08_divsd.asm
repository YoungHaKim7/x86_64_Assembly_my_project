; -----------------------------------------------------------------------------
; divsd -- double-precision division
;
; Demonstrates: divsd
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_08.lst ch18_08_divsd.asm && ld -g -o ch18_08_divsd ch18_08_divsd.o
; Run:    ./ch18_08_divsd ; echo $?        -> exit code: 12
;
; 100.0 / 8.0 = 12.5 exactly (8 is a power of two).
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dblA        dq  100.0
    dblB        dq  8.0

section .text
global _start
_start:
    movsd   xmm0, qword [dblA]
    divsd   xmm0, qword [dblB]         ; xmm0 = 12.5
    cvttsd2si rax, xmm0                ; 12

last:
    mov     rdi, rax                    ; exit status = 12
    mov     rax, SYS_exit
    syscall
