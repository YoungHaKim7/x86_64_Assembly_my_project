; -----------------------------------------------------------------------------
; Arrays are consecutive elements in the data section
;
; Demonstrates: dd list declaration, scaled indexing to reach element 1
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.4 (Data Section)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_10_array_variables.lst ch04_10_array_variables.asm && ld -g -o ch04_10_array_variables ch04_10_array_variables.o
; Run:    ./ch04_10_array_variables ; echo $?        -> exit code: 200
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd 100, 200, 300             ; dword array: elements 0, 1, 2

section .text
global _start
_start:

    mov     eax, dword [dArr + 4]            ; element 1: skip 4 bytes per dword

    mov     rdi, rax                         ; exit code 200

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
