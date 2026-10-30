; -----------------------------------------------------------------------------
; fabs via bitmask -- clearing the sign bit with andps
;
; Demonstrates: IEEE-754 sign bit manipulation
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 3.3.1 and 18.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_24.lst ch18_24_fabs_bitmask.asm && ld -g -o ch18_24_fabs_bitmask ch18_24_fabs_bitmask.o
; Run:    ./ch18_24_fabs_bitmask ; echo $?        -> exit code: 7
;
; The sign lives in the top bit; ANDing with 0x7FFFFFFF clears it, giving
; |x| without any comparison or negation.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltNeg      dd  -7.5
    absMask     dd  0x7FFFFFFF          ; all bits except the sign

section .text
global _start
_start:
    movss   xmm0, dword [fltNeg]
    movss   xmm1, dword [absMask]
    andps   xmm0, xmm1                 ; |−7.5| = 7.5
    cvttss2si rax, xmm0                ; 7

last:
    mov     rdi, rax                    ; exit status = 7
    mov     rax, SYS_exit
    syscall
