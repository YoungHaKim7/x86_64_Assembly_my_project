; -----------------------------------------------------------------------------
; ROR a byte by 1: 0x81 ror 1 -> 0xC0 = 192 (LSB wraps to bit 7)
;
; Demonstrates: ror (rotate right) -- bits leaving the bottom re-enter at
;               the top
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_104.lst ch07_104_ror_byte.asm && ld -g -o ch07_104 ch07_104_ror_byte.o
; Run:    ./ch07_104 ; echo $?        -> exit code: 192
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; ROR rotates the other way: the bit shifted out of bit 0 comes back in
; at bit 7 (a copy also lands in CF):
;
;       0x81 = 1000 0001
;       ror 1: the trailing 1 wraps to the top
;            = 1100 0000 = 0xC0 = 192
    mov     al, 0x81                    ; al = 1000 0001
    ror     al, 1                       ; al = 1100 0000 = 192 (CF = 1 too)

last:
    movzx   rdi, al                     ; exit status = 192
    mov     rax, SYS_exit               ; call code for exit
    syscall
