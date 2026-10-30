; -----------------------------------------------------------------------------
; Floating-point variables stored as raw bit patterns
;
; Demonstrates: dd 3.5 declaration, shifting out the mantissa bits
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.4 (Data Section)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_11_float_variables.lst ch04_11_float_variables.asm && ld -g -o ch04_11_float_variables ch04_11_float_variables.o
; Run:    ./ch04_11_float_variables ; echo $?        -> exit code: 64
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    flt1        dd 3.5                       ; IEEE-754 bits: 0x40600000

section .text
global _start
_start:

    mov     eax, dword [flt1]                ; load the raw bit pattern
    shr     eax, 24                          ; keep the top byte: 0x40 (sign+exponent)

    mov     rdi, rax                         ; exit code 64 (0x40)

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
