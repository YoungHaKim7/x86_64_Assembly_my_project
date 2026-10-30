; -----------------------------------------------------------------------------
; fneg via bitmask -- flipping the sign bit with xorps
;
; Demonstrates: sign toggle without arithmetic
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 3.3.1 and 18.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_25.lst ch18_25_fneg_bitmask.asm && ld -g -o ch18_25_fneg_bitmask ch18_25_fneg_bitmask.o
; Run:    ./ch18_25_fneg_bitmask ; echo $?        -> exit code: 253
;
; XOR with 0x80000000 flips only the sign bit: 3.5 -> -3.5 -> trunc -3,
; which the shell reports as 253.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltA        dd  3.5
    signMask    dd  0x80000000          ; sign bit only

section .text
global _start
_start:
    movss   xmm0, dword [fltA]
    movss   xmm1, dword [signMask]
    xorps   xmm0, xmm1                 ; 3.5 -> -3.5
    cvttss2si rax, xmm0                ; -3

last:
    mov     rdi, rax                    ; exit status = 253 (low byte of -3)
    mov     rax, SYS_exit
    syscall
