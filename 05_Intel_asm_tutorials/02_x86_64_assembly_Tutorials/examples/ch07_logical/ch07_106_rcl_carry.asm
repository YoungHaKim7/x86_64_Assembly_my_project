; -----------------------------------------------------------------------------
; RCL rotates through carry: stc; 0x7F rcl 1 -> 0xFF = 255
;
; Demonstrates: rcl (rotate through carry left) -- CF acts as a 9th bit
;               of the rotation ring
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_106.lst ch07_106_rcl_carry.asm && ld -g -o ch07_106 ch07_106_rcl_carry.o
; Run:    ./ch07_106 ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; RCL rotates a 9-bit ring made of CF and the byte: the old CF enters
; bit 0 while the old bit 7 moves into CF.  Seeding CF with 1 first:
;
;       CF=1, al = 0x7F = 0111 1111
;       rcl 1: al = (0x7F << 1) | old CF = 1111 1110 | 1 = 0xFF
;
; The 1 planted in the carry shows up in bit 0 -- proof the carry really
; participates in the rotation.
    stc                                 ; CF = 1 (rotation input bit)
    mov     al, 0x7F                    ; al = 0111 1111
    rcl     al, 1                       ; al = 1111 1111 = 255 (CF now 0)

last:
    movzx   rdi, al                     ; exit status = 255
    mov     rax, SYS_exit               ; call code for exit
    syscall
