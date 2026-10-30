; -----------------------------------------------------------------------------
; Two's complement negate of a word
;
; Demonstrates: neg ax (0 - 100 = -100 = 0xFF9C)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.1.3 (Word Example)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_02_twos_complement_word.lst ch03_02_twos_complement_word.asm && ld -g -o ch03_02_twos_complement_word ch03_02_twos_complement_word.o
; Run:    ./ch03_02_twos_complement_word ; echo $?        -> exit code: 156
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     ax, 100                         ; signed word +100
    neg     ax                              ; negate: 0 - 100 = 0xFF9C (-100)

; ax = 0xFF9C: low byte 0x9C = 156
    movzx   rdi, al                         ; exit code 156

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
