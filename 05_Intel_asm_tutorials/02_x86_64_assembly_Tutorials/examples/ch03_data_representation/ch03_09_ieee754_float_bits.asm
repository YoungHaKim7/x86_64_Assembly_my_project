; -----------------------------------------------------------------------------
; IEEE-754 single precision: bit pattern of 1.0
;
; Demonstrates: dd float storage, shr/and to slice out the exponent field
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.3.1 (IEEE 32-bit Representation)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_09_ieee754_float_bits.lst ch03_09_ieee754_float_bits.asm && ld -g -o ch03_09_ieee754_float_bits ch03_09_ieee754_float_bits.o
; Run:    ./ch03_09_ieee754_float_bits ; echo $?        -> exit code: 127
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    flt1        dd 1.0                      ; bits: 0 01111111 000...0 = 0x3F800000

section .text
global _start
_start:

    mov     eax, dword [flt1]               ; load the raw 32-bit pattern
    shr     eax, 23                         ; drop the mantissa (23 bits)
    and     eax, 0xFF                       ; keep the 8-bit biased exponent

; eax = 127: 1.0 = 1.0 x 2^0, biased exponent 0 + 127 = 127
    mov     rdi, rax                        ; exit code 127

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
