; -----------------------------------------------------------------------------
; Truncating a negative float -- toward ZERO, not toward minus infinity
;
; Demonstrates: cvttss2si direction on negative values
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.4 (Integer/FP Conversion)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_21.lst ch18_21_trunc_negative.asm && ld -g -o ch18_21_trunc_negative ch18_21_trunc_negative.o
; Run:    ./ch18_21_trunc_negative ; echo $?        -> exit code: 254
;
; -2.7 truncates to -2 (not -3); as an exit-status byte that is 254.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltA        dd  -2.7

section .text
global _start
_start:
    movss   xmm0, dword [fltA]
    cvttss2si rax, xmm0                ; -2

last:
    mov     rdi, rax                    ; exit status = 254 (low byte of -2)
    mov     rax, SYS_exit
    syscall
