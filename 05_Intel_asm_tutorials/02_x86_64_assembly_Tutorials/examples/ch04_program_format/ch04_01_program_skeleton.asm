; -----------------------------------------------------------------------------
; Bare program skeleton: data, bss, text sections and _start
;
; Demonstrates: the minimal structure of every program in this collection
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.0 (Program Format)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_01_program_skeleton.lst ch04_01_program_skeleton.asm && ld -g -o ch04_01_program_skeleton ch04_01_program_skeleton.o
; Run:    ./ch04_01_program_skeleton ; echo $?        -> exit code: 7
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data                          ; initialized data (empty in this skeleton)

section .bss                           ; uninitialized data (empty in this skeleton)

section .text
global _start
_start:

    ; program logic goes here
    mov     rdi, 7                     ; this skeleton just exits with 7

last:
    mov     rax, SYS_exit              ; call code for exit
    syscall
