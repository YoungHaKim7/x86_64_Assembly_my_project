; -----------------------------------------------------------------------------
; add: byte-sized addition (100 + 155 = 255)
;
; Demonstrates: add instruction with byte operands, memory-to-register add
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_31_add_bytes.lst ch07_31_add_bytes.asm && ld -g -o ch07_31_add_bytes ch07_31_add_bytes.o
; Run:    ./ch07_31_add_bytes ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db 100                   ; first byte operand
    bVar2       db 155                   ; second byte operand

section .bss
    bResult     resb 1                   ; room for the byte result

section .text
global _start
_start:

; bResult = bVar1 + bVar2   (100 + 155 = 255 = 0xFF, no carry out of 8 bits)
    mov     al, byte [bVar1]             ; al = 100
    add     al, byte [bVar2]             ; al = 100 + 155 = 255
    mov     byte [bResult], al           ; store the result in memory

; exit status keeps only the low 8 bits, and 255 already fits a byte
    mov     rdi, 0                       ; clear rdi (only al holds data)
    mov     dil, byte [bResult]          ; rdi = 255

last:
    mov     rax, SYS_exit                ; call code for exit
    syscall
