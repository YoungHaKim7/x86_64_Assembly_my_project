; -----------------------------------------------------------------------------
; cvtsi2ss -- integer to float
;
; Demonstrates: int -> float -> int round trip
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.4 (Integer/FP Conversion)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_18.lst ch18_18_cvtsi2ss.asm && ld -g -o ch18_18_cvtsi2ss ch18_18_cvtsi2ss.o
; Run:    ./ch18_18_cvtsi2ss ; echo $?        -> exit code: 7
;
; Small integers are exact in float, so 7 -> 7.0f -> 7.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, 7
    cvtsi2ss xmm0, rax                 ; xmm0 = 7.0f
    cvttss2si rbx, xmm0                ; back to integer 7
    mov     rax, rbx

last:
    mov     rdi, rax                    ; exit status = 7
    mov     rax, SYS_exit
    syscall
