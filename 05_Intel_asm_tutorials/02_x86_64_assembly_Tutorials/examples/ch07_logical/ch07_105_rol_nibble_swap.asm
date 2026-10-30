; -----------------------------------------------------------------------------
; Swap the nibbles of a byte: 0x12 rol 4 -> 0x21 = 33
;
; Demonstrates: rol by 4 exchanging the high and low nibbles of a byte
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_105.lst ch07_105_rol_nibble_swap.asm && ld -g -o ch07_105 ch07_105_rol_nibble_swap.o
; Run:    ./ch07_105 ; echo $?        -> exit code: 33
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; A byte has exactly 8 bits, so rotating by 4 moves the top nibble to the
; bottom and the bottom nibble to the top -- a nibble swap in one shot:
;
;       0x12 = 0001 0010
;       rol 4 = 0010 0001 = 0x21 = 33
;
; Rotating by 4 twice returns the original byte (8-bit rotate is cyclic).
    mov     al, 0x12                    ; al = 0001 0010
    rol     al, 4                       ; al = 0010 0001 = 33

; Do it again to show the swap reverses itself: 0x21 -> 0x12.
; The exit code uses the single-swap value kept safe in bl.
    mov     bl, al                      ; bl = 33 (the swapped value)
    rol     al, 4                       ; al back to 0x12 (18)

last:
    movzx   rdi, bl                     ; exit status = 33 (one nibble swap)
    mov     rax, SYS_exit               ; call code for exit
    syscall
