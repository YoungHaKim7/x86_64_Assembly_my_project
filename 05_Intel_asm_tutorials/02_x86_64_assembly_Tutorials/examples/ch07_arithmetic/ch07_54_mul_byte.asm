; -----------------------------------------------------------------------------
; mul (byte form): al = 12, mul bl (11) -> ax = 132
;
; Demonstrates: unsigned byte multiply mul, word-sized product in ax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_54.lst ch07_54_mul_byte.asm && ld -g -o ch07_54 ch07_54_mul_byte.o
; Run:    ./ch07_54 ; echo $?        -> exit code: 132
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVal1       db 12                   ; byte multiplicand
    bVal2       db 11                   ; byte multiplier

section .bss
    wProduct    resw 1                  ; word-sized product storage

section .text
global _start
_start:

; For the byte form of mul the multiplicand MUST be in al.  The product of
; two bytes can need up to 16 bits, so the result is placed in all of ax
; (ah holds the high byte of the product, here 0).
    mov     al, byte [bVal1]            ; al = 12 (multiplicand, must be al)
    mov     bl, byte [bVal2]            ; bl = 11 (multiplier)
    mul     bl                          ; ax = al * bl = 132

    mov     word [wProduct], ax         ; save the word product (132)
    movzx   edi, word [wProduct]        ; widen to 64 bits for the exit status

; Exit with the product (132 fits nicely in the 0..255 exit-code range).
last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status already in rdi (132)
