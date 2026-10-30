; -----------------------------------------------------------------------------
; rFlags: the carry flag (CF) on 8-bit unsigned overflow
;
; Demonstrates: add setting CF, conditional jump jc
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 2.3.1.5 (Flag Register)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch02_08_rflags_carry_bit.lst ch02_08_rflags_carry_bit.asm && ld -g -o ch02_08_rflags_carry_bit ch02_08_rflags_carry_bit.o
; Run:    ./ch02_08_rflags_carry_bit ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     al, 255                         ; largest unsigned byte (0xFF)
    add     al, 1                           ; 255 + 1 = 256 > 255 -> CF = 1, al = 0

    mov     rdi, 0                          ; assume the carry flag is clear
    jnc     last                            ; skip ahead when CF = 0
    mov     rdi, 1                          ; CF was set: the byte result wrapped

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
