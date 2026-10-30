; -----------------------------------------------------------------------------
; Sign extension: byte -5 widened to a qword
;
; Demonstrates: movsx r64, r/m8 (copies the sign bit into every upper bit)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.1 (Integer Representation)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_05_sign_extension.lst ch03_05_sign_extension.asm && ld -g -o ch03_05_sign_extension ch03_05_sign_extension.o
; Run:    ./ch03_05_sign_extension ; echo $?        -> exit code: 251
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db -5                       ; signed byte, stored as 0xFB

section .text
global _start
_start:

    movsx   rax, byte [bVar1]               ; sign-extend the byte into all 64 bits

; rax = 0xFFFFFFFFFFFFFFFB = qword -5 (same value, wider storage)
    movzx   rdi, al                         ; low byte 0xFB = 251

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
