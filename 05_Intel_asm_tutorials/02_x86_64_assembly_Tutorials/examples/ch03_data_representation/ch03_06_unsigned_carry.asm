; -----------------------------------------------------------------------------
; Unsigned addition overflow: carry flag (CF)
;
; Demonstrates: 0xFF + 1 as bytes wraps and sets CF
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.2 (Unsigned and Signed Addition)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_06_unsigned_carry.lst ch03_06_unsigned_carry.asm && ld -g -o ch03_06_unsigned_carry ch03_06_unsigned_carry.o
; Run:    ./ch03_06_unsigned_carry ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     al, 0xFF                        ; 255: largest unsigned byte
    add     al, 1                           ; unsigned 256 > 255 -> CF = 1, al = 0

    mov     rdi, 0                          ; result 0 while CF is clear
    jnc     last                            ; CF = 0 -> no unsigned overflow
    mov     rdi, 1                          ; CF = 1: unsigned sum exceeded 255

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
