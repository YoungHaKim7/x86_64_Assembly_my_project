; -----------------------------------------------------------------------------
; XOR to invert bits: 0xF0 xor 0xFF -> 0x0F (15)
;
; Demonstrates: xor instruction toggling every bit of the operand
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_85.lst ch07_85_xor_toggle.asm && ld -g -o ch07_85 ch07_85_xor_toggle.o
; Run:    ./ch07_85 ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; XOR works like "invert where the mask is 1, keep where the mask is 0":
; a 1 in the mask flips that operand bit, a 0 leaves it alone.  The all-ones
; mask 0xFF therefore complements the whole byte at once:
;
;       0xF0 = 1111 0000
;   XOR 0xFF = 1111 1111
;       -----------------
;       0x0F = 0000 1111   (15 -- every bit flipped)
    mov     al, 0xF0                    ; al = 1111 0000
    xor     al, 0xFF                    ; al = 0000 1111 = 0x0F (15)

; XORing twice with the same mask restores the original value
; (toggle is its own inverse): 0x0F xor 0xFF = 0xF0 again.
    mov     bl, al                      ; bl = 0x0F (keep for the exit code)
    xor     al, 0xFF                    ; al back to 0xF0 (240)

last:
    movzx   rdi, bl                     ; exit status = 15 (the toggled value)
    mov     rax, SYS_exit               ; call code for exit
    syscall
