; -----------------------------------------------------------------------------
; Sub-registers: al is the low byte of ax/eax/rax
;
; Demonstrates: writing al leaves the rest of rax untouched
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 2.3.1.1 (General Purpose Registers)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch02_02_gpr_sizes.lst ch02_02_gpr_sizes.asm && ld -g -o ch02_02_gpr_sizes ch02_02_gpr_sizes.o
; Run:    ./ch02_02_gpr_sizes ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global main
main:

    xor     rax, rax                        ; rax = 0 (all 64 bits cleared)
    mov     al, 0xFF                        ; write ONLY the low 8 bits

; rax = 0x00000000000000FF: the 8-bit write touched no other part of rax
    mov     rdi, rax                        ; exit code 255 (0xFF)

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
