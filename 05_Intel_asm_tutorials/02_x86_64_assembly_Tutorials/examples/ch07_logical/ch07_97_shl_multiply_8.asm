; -----------------------------------------------------------------------------
; SHL as multiply-by-8: 5 shl 3 = 40
;
; Demonstrates: shl by 3 multiplying by 2^3 = 8 in one instruction
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_97.lst ch07_97_shl_multiply_8.asm && ld -g -o ch07_97 ch07_97_shl_multiply_8.o
; Run:    ./ch07_97 ; echo $?        -> exit code: 40
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Each position shifted left multiplies by 2, so shl 3 multiplies by 8:
; 5 = 0000 0101 -> 0010 1000 = 40 (= 5 * 8).
    mov     al, 5                       ; al = 0000 0101
    shl     al, 3                       ; al = 0010 1000 = 40 (5 * 2^3)

; The top bit shifted out lands in CF.  Nothing overflows the byte here,
; so CF = 0; had a 1 fallen off the top it would be lost, which is why
; shl is only equivalent to mul when no overflow occurs.

last:
    movzx   rdi, al                     ; exit status = 40
    mov     rax, SYS_exit               ; call code for exit
    syscall
