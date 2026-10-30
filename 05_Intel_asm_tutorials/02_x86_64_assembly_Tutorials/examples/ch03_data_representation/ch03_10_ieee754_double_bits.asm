; -----------------------------------------------------------------------------
; IEEE-754 double precision: bit pattern of 1.0
;
; Demonstrates: dq double storage, shr/and to slice out the exponent field
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.3.2 (IEEE 64-bit Representation)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_10_ieee754_double_bits.lst ch03_10_ieee754_double_bits.asm && ld -g -o ch03_10_ieee754_double_bits ch03_10_ieee754_double_bits.o
; Run:    ./ch03_10_ieee754_double_bits ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dbl1        dq 1.0                      ; bits: 0 01111111111 000...0
                                            ;     = 0x3FF0000000000000

section .text
global _start
_start:

    mov     rax, qword [dbl1]               ; load the raw 64-bit pattern
    shr     rax, 52                         ; drop the mantissa (52 bits)
    and     rax, 0x7FF                      ; keep the 11-bit biased exponent

; rax = 1023: biased exponent 0 + 1023 = 1023 (0x3FF)
    movzx   rdi, al                         ; low byte of 1023 = 255

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
