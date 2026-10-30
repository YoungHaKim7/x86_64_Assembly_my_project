; -----------------------------------------------------------------------------
; cvtsd2si -- round-to-nearest-EVEN on ties
;
; Demonstrates: the IEEE default rounding mode (.5 ties go to even)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.4 (Integer/FP Conversion)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_20.lst ch18_20_cvtsd2si.asm && ld -g -o ch18_20_cvtsd2si ch18_20_cvtsd2si.o
; Run:    ./ch18_20_cvtsd2si ; echo $?        -> exit code: 6
;
; 6.5 is a tie: 6 and 7 are equally near; even wins -> 6.
; (7.5 would round to 8 for the same reason.)
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dblA        dq  6.5

section .text
global _start
_start:
    movsd   xmm0, qword [dblA]
    cvtsd2si rax, xmm0                 ; ties-to-even: 6

last:
    mov     rdi, rax                    ; exit status = 6
    mov     rax, SYS_exit
    syscall
