; -----------------------------------------------------------------------------
; sub: byte-sized subtraction (255 - 55 = 200)
;
; Demonstrates: sub instruction with byte operands, memory-to-register sub
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_38.lst ch07_38_sub_bytes.asm && ld -g -o ch07_38 ch07_38_sub_bytes.o
; Run:    ./ch07_38 ; echo $?        -> exit code: 200
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db 255                    ; minuend (byte)
    bVar2       db 55                     ; subtrahend (byte)

section .bss
    bResult     resb 1                    ; room for the byte result

section .text
global _start
_start:

; bResult = bVar1 - bVar2   (255 - 55 = 200 = 0xC8, no borrow)
    mov     al, byte [bVar1]              ; al = 255
    sub     al, byte [bVar2]              ; al = 255 - 55 = 200
    mov     byte [bResult], al            ; store the result in memory

; 200 fits the 0..255 exit-code range directly
    mov     rdi, 0                        ; clear rdi (only al holds data)
    mov     dil, byte [bResult]           ; rdi = 200

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
