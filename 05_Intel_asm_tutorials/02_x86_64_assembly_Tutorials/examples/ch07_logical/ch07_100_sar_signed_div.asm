; -----------------------------------------------------------------------------
; SAR as signed divide-by-4: -100 sar 2 = -25 (byte 231)
;
; Demonstrates: sar (arithmetic shift right) dividing a negative number
;               while preserving its sign
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_100.lst ch07_100_sar_signed_div.asm && ld -g -o ch07_100 ch07_100_sar_signed_div.o
; Run:    ./ch07_100 ; echo $?        -> exit code: 231
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; SAR shifts copies of the sign bit in from the top, so a negative value
; stays negative (it rounds toward minus infinity):
;
;       -100 = 0x9C = 1001 1100
;       sar 2         1110 0111 = 0xE7 = -25 signed / 231 unsigned
;
; The mathematical result is -25; the exit status is the low byte, 231.
    mov     al, -100                    ; al = 1001 1100 (0x9C)
    sar     al, 2                       ; al = 1110 0111 (0xE7 = -25)

last:
    movzx   rdi, al                     ; exit status = 231 (low byte of -25)
    mov     rax, SYS_exit               ; call code for exit
    syscall
