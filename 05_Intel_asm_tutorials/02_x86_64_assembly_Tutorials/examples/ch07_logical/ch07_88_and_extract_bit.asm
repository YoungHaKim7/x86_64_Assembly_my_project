; -----------------------------------------------------------------------------
; Extract one bit: (0x2A shr 5) and 1 -> 1 (bit 5 of 0x2A is set)
;
; Demonstrates: shr moving a wanted bit into position 0, and and 1 to
;               isolate it
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_88.lst ch07_88_and_extract_bit.asm && ld -g -o ch07_88 ch07_88_and_extract_bit.o
; Run:    ./ch07_88 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; 0x2A = 0010 1010 -- bits 5, 3 and 1 are set.  To read bit 5 alone:
; step 1: shift right 5 so bit 5 lands in bit 0;
; step 2: AND with 1 to discard everything that followed it down.
;
;       0x2A         = 0010 1010
;       shr 5        = 0000 0001   (bit 5 now in position 0)
;       and 1        = 0000 0001   (1 -- the bit was set)
    mov     al, 0x2A                    ; al = 0010 1010
    shr     al, 5                       ; al = 0000 0001
    and     al, 1                       ; al = 1 (bit 5 was set)

last:
    movzx   rdi, al                     ; exit status = 1
    mov     rax, SYS_exit               ; call code for exit
    syscall
