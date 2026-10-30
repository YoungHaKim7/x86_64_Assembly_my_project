; -----------------------------------------------------------------------------
; String variables and the $ - label length idiom
;
; Demonstrates: db with a quoted string, equ on $ (current offset)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.4 (Data Section)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_09_string_variables.lst ch04_09_string_variables.asm && ld -g -o ch04_09_string_variables ch04_09_string_variables.o
; Run:    ./ch04_09_string_variables ; echo $?        -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    strng       db  "Hello"                  ; 5 bytes, no terminator
    len         equ $ - strng                ; offset here minus offset of strng = 5

section .text
global _start
_start:

    mov     rdi, len                         ; exit code 5 (length of "Hello")

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
