; -----------------------------------------------------------------------------
; cvttss2si -- TRUNCATE toward zero
;
; Demonstrates: the extra 't' means truncation, not rounding
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.4 (Integer/FP Conversion)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_17.lst ch18_17_cvttss2si.asm && ld -g -o ch18_17_cvttss2si ch18_17_cvttss2si.o
; Run:    ./ch18_17_cvttss2si ; echo $?        -> exit code: 3
;
; 3.7 truncates down to 3.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltA        dd  3.7

section .text
global _start
_start:
    movss   xmm0, dword [fltA]
    cvttss2si rax, xmm0                ; chop the fraction: 3

last:
    mov     rdi, rax                    ; exit status = 3
    mov     rax, SYS_exit
    syscall
