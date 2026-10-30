; -----------------------------------------------------------------------------
; neg: negate a byte (5 -> -5 = 0xFB)
;
; Demonstrates: neg instruction with a byte operand, two's complement
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_45.lst ch07_45_neg_byte.asm && ld -g -o ch07_45 ch07_45_neg_byte.o
; Run:    ./ch07_45 ; echo $?        -> exit code: 251
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db 5                      ; byte to negate

section .text
global _start
_start:

; neg replaces its operand with its two's complement: 0 - operand.
; neg 5 computes 0 - 5 = 0xFB, which reads as -5 signed or 251 unsigned
    mov     al, byte [bVar1]              ; al = 5
    neg     al                            ; al = 0xFB (251 unsigned, -5 signed)

; SF is set (result MSB = 1); the unsigned byte value 251 is the exit code
    mov     rdi, 0                        ; clear rdi (only al holds data)
    mov     dil, al                       ; rdi = 251

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
