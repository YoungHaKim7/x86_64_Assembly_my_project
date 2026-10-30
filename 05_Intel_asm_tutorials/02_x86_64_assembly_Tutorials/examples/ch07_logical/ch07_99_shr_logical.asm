; -----------------------------------------------------------------------------
; SHR is a LOGICAL shift: zeros enter from the top (0xFF shr 4 = 0x0F)
;
; Demonstrates: shr always shifting in 0 bits regardless of the sign bit
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_99.lst ch07_99_shr_logical.asm && ld -g -o ch07_99 ch07_99_shr_logical.o
; Run:    ./ch07_99 ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; 0xFF has every bit set (and reads as -1 when treated as signed), yet SHR
; still moves plain 0s into the vacated high positions:
;
;       0xFF = 1111 1111
;       shr 4 = 0000 1111 = 0x0F (15)
;
; The signed flavour, SAR, would instead copy the sign bit and keep the
; value at 0xFF (255 as a byte) -- see ch07_101 for that contrast.
    mov     al, 0xFF                    ; al = 1111 1111
    shr     al, 4                       ; al = 0000 1111 = 15 (zeros shifted in)

last:
    movzx   rdi, al                     ; exit status = 15
    mov     rax, SYS_exit               ; call code for exit
    syscall
