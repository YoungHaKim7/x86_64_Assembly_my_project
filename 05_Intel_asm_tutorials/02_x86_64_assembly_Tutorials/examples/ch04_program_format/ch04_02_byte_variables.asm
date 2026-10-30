; -----------------------------------------------------------------------------
; Byte variables in the data section
;
; Demonstrates: db declaration, byte load, 8-bit add
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.4 (Data Section)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_02_byte_variables.lst ch04_02_byte_variables.asm && ld -g -o ch04_02_byte_variables ch04_02_byte_variables.o
; Run:    ./ch04_02_byte_variables ; echo $?        -> exit code: 52
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db 42                        ; byte variable, initial value 42

section .text
global _start
_start:

    mov     al, byte [bVar1]                 ; al = 42
    add     al, 10                           ; al = 42 + 10 = 52

    movzx   rdi, al                          ; exit code 52

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
