; -----------------------------------------------------------------------------
; OR to set selected bits: 0x0A or 0x40 -> 0x4A (74)
;
; Demonstrates: or instruction turning individual bits on without
;               disturbing the bits already set
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_83.lst ch07_83_or_set_bits.asm && ld -g -o ch07_83 ch07_83_or_set_bits.o
; Run:    ./ch07_83 ; echo $?        -> exit code: 74
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; An OR mask of 1 bits forces those positions to 1; 0 bits leave the
; operand alone.  Here bit 6 (value 0x40) is switched on:
;
;       0x0A = 0000 1010
;    OR 0x40 = 0100 0000
;       -----------------
;       0x4A = 0100 1010   (74 -- original bits 3 and 1 still set)
    mov     al, 0x0A                    ; al = 0000 1010
    or      al, 0x40                    ; al = 0100 1010 = 0x4A (74)

last:
    movzx   rdi, al                     ; exit status = 74
    mov     rax, SYS_exit               ; call code for exit
    syscall
