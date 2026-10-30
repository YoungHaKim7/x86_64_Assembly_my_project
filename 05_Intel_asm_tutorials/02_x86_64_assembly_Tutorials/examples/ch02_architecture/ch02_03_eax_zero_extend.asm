; -----------------------------------------------------------------------------
; 32-bit writes zero the upper half of the 64-bit register
;
; Demonstrates: mov eax, <src> always zero-extends into rax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 2.3.1.1 (General Purpose Registers)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch02_03_eax_zero_extend.lst ch02_03_eax_zero_extend.asm && ld -g -o ch02_03_eax_zero_extend ch02_03_eax_zero_extend.o
; Run:    ./ch02_03_eax_zero_extend ; echo $?        -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     rax, -1                         ; rax = 0xFFFFFFFFFFFFFFFF
    mov     eax, 5                          ; 32-bit destination -> upper 32 bits zeroed

; rax = 0x0000000000000005, NOT 0xFFFFFFFF00000005
    mov     rdi, rax                        ; exit code 5

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
