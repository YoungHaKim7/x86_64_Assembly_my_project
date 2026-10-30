; -----------------------------------------------------------------------------
; cvtss2si -- round to NEAREST (default rounding mode)
;
; Demonstrates: rounding conversion, contrast with truncation
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.4 (Integer/FP Conversion)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_16.lst ch18_16_cvtss2si.asm && ld -g -o ch18_16_cvtss2si ch18_16_cvtss2si.o
; Run:    ./ch18_16_cvtss2si ; echo $?        -> exit code: 4
;
; 3.7 rounds up to 4 (nearest); see ch18_17 for the truncating variant.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltA        dd  3.7

section .text
global _start
_start:
    movss   xmm0, dword [fltA]
    cvtss2si rax, xmm0                 ; round-to-nearest: 4

last:
    mov     rdi, rax                    ; exit status = 4
    mov     rax, SYS_exit
    syscall
