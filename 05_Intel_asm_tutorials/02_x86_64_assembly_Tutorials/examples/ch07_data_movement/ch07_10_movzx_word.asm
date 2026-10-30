; -----------------------------------------------------------------------------
; movzx: moving a word with zero-extension
;
; Demonstrates: movzx reg64, word [mem] — unsigned word load
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_10.lst ch07_10_movzx_word.asm && ld -g -o ch07_10 ch07_10_movzx_word.o
; Run:    ./ch07_10 ; echo $?        -> exit code: 52
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    wVar        dw 0x1234            ; one word, 0x1234 = 4660 decimal

section .text
global _start
_start:

    mov     rcx, -1                  ; fill rcx with 1-bits first

; movzx zero-extends the 16-bit source into the full 64-bit register:
; the word lands in the low 16 bits and zeros fill the rest.
    movzx   rcx, word [wVar]         ; rcx = 0x0000000000001234 = 4660

; The full result is 4660, but the shell keeps only the low 8 bits of
; the exit status:  4660 AND 0xFF = 0x34 = 52.
last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rcx                 ; exit status = low byte = 52
    syscall
