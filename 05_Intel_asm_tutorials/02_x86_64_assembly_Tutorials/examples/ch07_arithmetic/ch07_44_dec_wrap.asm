; -----------------------------------------------------------------------------
; dec: decrement below zero wraps a byte (0 -> 255)
;
; Demonstrates: dec instruction, unsigned wraparound, sign flag (SF) after dec
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_44.lst ch07_44_dec_wrap.asm && ld -g -o ch07_44 ch07_44_dec_wrap.o
; Run:    ./ch07_44 ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bCount      db 0                      ; byte counter at zero

section .text
global _start
_start:

; dec subtracts 1 from its operand. At 0 the byte wraps to 0xFF:
;   unsigned reading: 255 (2^8 - 1)
;   signed reading:   -1 (SF becomes 1 because the MSB is set)
    mov     al, byte [bCount]             ; al = 0
    dec     al                            ; al = 0xFF = 255 unsigned (-1 signed)
                                            ; SF = 1, ZF = 0, CF unchanged (see
                                            ; the inc/dec carry quirk demo)
; the wrapped unsigned value 255 is the exit code
    mov     rdi, 0                        ; clear rdi (only al holds data)
    mov     dil, al                       ; rdi = 255

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
