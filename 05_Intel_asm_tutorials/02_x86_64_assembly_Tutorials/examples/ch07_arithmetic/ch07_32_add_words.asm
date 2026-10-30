; -----------------------------------------------------------------------------
; add: word-sized addition (30000 + 123 = 30123)
;
; Demonstrates: add instruction with word (16-bit) operands
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_32_add_words.lst ch07_32_add_words.asm && ld -g -o ch07_32_add_words ch07_32_add_words.o
; Run:    ./ch07_32_add_words ; echo $?        -> exit code: 171
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    wVar1       dw 30000                 ; first word operand
    wVar2       dw 123                   ; second word operand

section .bss
    wResult     resw 1                   ; room for the word result

section .text
global _start
_start:

; wResult = wVar1 + wVar2   (full result: 30000 + 123 = 30123 = 0x75AB)
    mov     ax, word [wVar1]             ; ax = 30000
    add     ax, word [wVar2]             ; ax = 30123 (0x75AB), no carry
    mov     word [wResult], ax           ; store the full 16-bit result

; the shell keeps only the low 8 bits of the exit status:
; 30123 & 0xFF = 0xAB = 171
    mov     rdi, 0                       ; clear rdi first
    mov     di, word [wResult]           ; rdi = 30123 -> exit code 171

last:
    mov     rax, SYS_exit                ; call code for exit
    syscall
