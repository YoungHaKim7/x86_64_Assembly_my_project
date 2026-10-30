; -----------------------------------------------------------------------------
; RCR rotates through carry: 0xFE rcr 1 -> 0x7F = 127 (with CF = 0)
;
; Demonstrates: rcr (rotate through carry right) -- the old CF lands in
;               bit 7 while bit 0 moves out into CF
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_107.lst ch07_107_rcr_carry.asm && ld -g -o ch07_107 ch07_107_rcr_carry.o
; Run:    ./ch07_107 ; echo $?        -> exit code: 127
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; RCR rotates the 9-bit CF:al ring to the right: old bit 0 goes to CF and
; the old CF value is shifted into bit 7 -- so the carry flag decides
; whether the result's top bit becomes 0 or 1.
;
; First with CF = 1 (stc):  al = 0xFE = 1111 1110
;       rcr 1 -> al = 0xFF (the carry 1 entered bit 7)
    mov     al, 0xFE                    ; al = 1111 1110
    stc                                 ; CF = 1
    rcr     al, 1                       ; al = 1111 1111 = 255

; Now with CF = 0 (clc):   al = 0xFE = 1111 1110
;       rcr 1 -> al = 0111 1111 = 0x7F (a 0 entered bit 7)
    mov     al, 0xFE                    ; reload the same operand
    clc                                 ; CF = 0
    rcr     al, 1                       ; al = 0111 1111 = 127

last:
    movzx   rdi, al                     ; exit status = 127
    mov     rax, SYS_exit               ; call code for exit
    syscall
