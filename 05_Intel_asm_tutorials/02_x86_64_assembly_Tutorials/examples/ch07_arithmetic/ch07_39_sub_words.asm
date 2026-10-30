; -----------------------------------------------------------------------------
; sub: word-sized subtraction (1000 - 388 = 612)
;
; Demonstrates: sub instruction with word (16-bit) operands
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_39.lst ch07_39_sub_words.asm && ld -g -o ch07_39 ch07_39_sub_words.o
; Run:    ./ch07_39 ; echo $?        -> exit code: 100
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    wVar1       dw 1000                   ; minuend (word)
    wVar2       dw 388                    ; subtrahend (word)

section .bss
    wResult     resw 1                    ; room for the word result

section .text
global _start
_start:

; wResult = wVar1 - wVar2   (full result: 1000 - 388 = 612 = 0x0264)
    mov     ax, word [wVar1]              ; ax = 1000
    sub     ax, word [wVar2]              ; ax = 612, no borrow
    mov     word [wResult], ax            ; store the full 16-bit result

; the shell keeps only the low 8 bits of the exit status:
; 612 & 0xFF = 0x64 = 100
    mov     rdi, 0                        ; clear rdi first
    mov     di, word [wResult]            ; rdi = 612 -> exit code 100

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
