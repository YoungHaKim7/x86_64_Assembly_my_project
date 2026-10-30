; -----------------------------------------------------------------------------
; AND as a bit mask: 0xAB and 0x0F keeps the low nibble -> 0x0B
;
; Demonstrates: and instruction clearing selected bits to extract a field
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_81.lst ch07_81_and_mask_nibble.asm && ld -g -o ch07_81 ch07_81_and_mask_nibble.o
; Run:    ./ch07_81 ; echo $?        -> exit code: 11
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; A mask of 1 bits passes the corresponding operand bits through unchanged,
; a mask of 0 bits clears them.  0x0F = 0000 1111 zeroes the high nibble:
;
;       0xAB = 1010 1011
;   AND 0x0F = 0000 1111
;       -----------------
;       0x0B = 0000 1011   (the low nibble 0xB, unharmed)
    mov     al, 0xAB                    ; al = 1010 1011
    and     al, 0x0F                    ; al = 0000 1011 = 0x0B (11)

last:
    movzx   rdi, al                     ; exit status = 11
    mov     rax, SYS_exit               ; call code for exit
    syscall
