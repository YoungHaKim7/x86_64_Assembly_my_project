; -----------------------------------------------------------------------------
; Word variables in the data section
;
; Demonstrates: dw declaration, word load, 16-bit add
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.4 (Data Section)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_03_word_variables.lst ch04_03_word_variables.asm && ld -g -o ch04_03_word_variables ch04_03_word_variables.o
; Run:    ./ch04_03_word_variables ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    wVar1       dw 100                       ; word variable, initial value 100

section .text
global _start
_start:

    mov     ax, word [wVar1]                 ; ax = 100
    add     ax, 155                          ; ax = 100 + 155 = 255 (0x00FF)

    movzx   rdi, ax                          ; exit code 255

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
