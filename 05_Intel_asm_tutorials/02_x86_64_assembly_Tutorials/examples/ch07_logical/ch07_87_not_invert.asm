; -----------------------------------------------------------------------------
; NOT: one's complement of a byte, 0x0F -> 0xF0 (240)
;
; Demonstrates: not instruction inverting every bit in place (no flags set)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_87.lst ch07_87_not_invert.asm && ld -g -o ch07_87 ch07_87_not_invert.o
; Run:    ./ch07_87 ; echo $?        -> exit code: 240
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar        db 0x0F                  ; 0000 1111 to be inverted

section .text
global _start
_start:

; NOT flips all bits in the operand -- it is the one's complement.
; Unlike neg (two's complement = NOT plus 1) it performs no addition,
; and unlike the logical instructions it sets no flags.
;
;       0x0F = 0000 1111
;   NOT       ----------  (every bit inverted)
;       0xF0 = 1111 0000   (240)
    not     byte [bVar]                 ; bVar = 1111 0000 = 0xF0
    movzx   rdi, byte [bVar]            ; rdi = 240

; Note this is NOT the negative of 0x0F: neg would give 0xF1 (-15),
; one more than the complement shown here.
    mov     al, 0x0F                    ; al = 0000 1111 again
    not     al                          ; al = 0xF0 (240, one's complement)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (240)
