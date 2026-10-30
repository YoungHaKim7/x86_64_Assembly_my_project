; -----------------------------------------------------------------------------
; jo: jump if the overflow flag signals signed overflow
;
; Demonstrates: byte add 127 + 1 -> OF = 1 -> jo taken
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_122.lst ch07_122_jo_overflow.asm && ld -g -o ch07_122 ch07_122_jo_overflow.o
; Run:    ./ch07_122 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db 127                ; +127: the largest signed byte

section .text
global _start
_start:

; A signed byte holds -128..+127.  Adding 1 to 127 cannot be represented:
; the 8-bit result 0x80 is the encoding of -128, so SIGNED arithmetic went
; wrong and OF = 1.  OF is set only when the sign of the answer contradicts
; the signs of the operands.  (Unsigned, 0x80 is just 128 — no carry.)
    mov     al, byte [bVar1]        ; al = 127
    mov     ebx, 0                  ; result if the jump is not taken
    add     al, 1                   ; wraps to -128: signed overflow -> OF = 1
    jo      overflowed              ; taken: OF signals signed overflow
    jmp     last                    ; (skipped by the jo)

overflowed:
    mov     ebx, 1                  ; report that jo fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
