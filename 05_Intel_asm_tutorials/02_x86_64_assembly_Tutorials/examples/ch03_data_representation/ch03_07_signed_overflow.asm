; -----------------------------------------------------------------------------
; Signed addition overflow: overflow flag (OF)
;
; Demonstrates: 127 + 1 as signed bytes sets OF (jo)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.2 (Unsigned and Signed Addition)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_07_signed_overflow.lst ch03_07_signed_overflow.asm && ld -g -o ch03_07_signed_overflow ch03_07_signed_overflow.o
; Run:    ./ch03_07_signed_overflow ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     al, 127                         ; 0x7F: largest signed byte
    add     al, 1                           ; signed +128 > 127 -> OF = 1, al = 0x80

    mov     rdi, 0                          ; result 0 while OF is clear
    jno     last                            ; OF = 0 -> no signed overflow
    mov     rdi, 1                          ; OF = 1: signed sum out of range

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
