; -----------------------------------------------------------------------------
; cvtsi2sd -- integer to double
;
; Demonstrates: 64-bit ints are exact as doubles
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.4 (Integer/FP Conversion)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_19.lst ch18_19_cvtsi2sd.asm && ld -g -o ch18_19_cvtsi2sd ch18_19_cvtsi2sd.o
; Run:    ./ch18_19_cvtsi2sd ; echo $?        -> exit code: 9
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, 9
    cvtsi2sd xmm0, rax                 ; xmm0 = 9.0
    cvttsd2si rbx, xmm0                ; 9
    mov     rax, rbx

last:
    mov     rdi, rax                    ; exit status = 9
    mov     rax, SYS_exit
    syscall
