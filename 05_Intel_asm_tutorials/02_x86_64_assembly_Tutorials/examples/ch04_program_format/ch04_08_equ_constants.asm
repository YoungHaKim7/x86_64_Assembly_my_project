; -----------------------------------------------------------------------------
; Assembler-time constants with equ
;
; Demonstrates: equ symbol used like an immediate, shr to divide by a power of 2
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.3 (Defining Constants)
;
; Note: the constant is named dSize because yasm reserves the word "size".
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_08_equ_constants.lst ch04_08_equ_constants.asm && ld -g -o ch04_08_equ_constants ch04_08_equ_constants.o
; Run:    ./ch04_08_equ_constants ; echo $?        -> exit code: 9
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

dSize            equ 36                      ; constant resolved at assembly time

section .text
global _start
_start:

    mov     rax, dSize                       ; rax = 36
    shr     rax, 2                           ; rax = dSize / 4 = 9

    mov     rdi, rax                         ; exit code 9

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
