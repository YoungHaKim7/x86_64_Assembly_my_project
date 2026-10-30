; -----------------------------------------------------------------------------
; ROL a byte by 1: 0x81 rol 1 -> 0x03 (MSB wraps around to bit 0)
;
; Demonstrates: rol (rotate left) -- bits leaving the top re-enter at the
;               bottom, so nothing is lost
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_103.lst ch07_103_rol_byte.asm && ld -g -o ch07_103 ch07_103_rol_byte.o
; Run:    ./ch07_103 ; echo $?        -> exit code: 3
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; ROL treats the byte as a ring: the bit shifted out of bit 7 comes back
; in at bit 0 (a copy also lands in CF).  Unlike shl, no bit is discarded:
;
;       0x81 = 1000 0001
;       rol 1: the leading 1 wraps to the bottom
;            = 0000 0011 = 0x03
    mov     al, 0x81                    ; al = 1000 0001
    rol     al, 1                       ; al = 0000 0011 = 3 (CF = 1 too)

last:
    movzx   rdi, al                     ; exit status = 3
    mov     rax, SYS_exit               ; call code for exit
    syscall
