; -----------------------------------------------------------------------------
; Two's complement negate of a byte
;
; Demonstrates: neg al (0 - 5 = -5 = 0xFB)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.1.2 (Byte Example)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_01_twos_complement_byte.lst ch03_01_twos_complement_byte.asm && ld -g -o ch03_01_twos_complement_byte ch03_01_twos_complement_byte.o
; Run:    ./ch03_01_twos_complement_byte ; echo $?        -> exit code: 251
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     al, 5                           ; signed byte +5
    neg     al                              ; negate: 0 - 5 = 0xFB (-5)

; al = 0xFB = 251: the two's complement bit pattern of -5
    movzx   rdi, al                         ; exit code 251

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
