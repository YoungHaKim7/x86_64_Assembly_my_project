; -----------------------------------------------------------------------------
; Dword variables in the data section
;
; Demonstrates: dd declaration, dword load/add, keeping the low 8 bits
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.4 (Data Section)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_04_dword_variables.lst ch04_04_dword_variables.asm && ld -g -o ch04_04_dword_variables ch04_04_dword_variables.o
; Run:    ./ch04_04_dword_variables ; echo $?        -> exit code: 4
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 100000                    ; dword variable, initial value 100000

section .text
global _start
_start:

    mov     eax, dword [dVar1]               ; eax = 100000
    add     eax, 100                         ; eax = 100100 (full result 0x00018704)

    and     eax, 0xFF                        ; keep only the low byte: 100100 & 255 = 4

    mov     rdi, rax                         ; exit code 4

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
