; -----------------------------------------------------------------------------
; A string is a byte array: "Hi" and its length
;
; Demonstrates: db with a text literal, the $ - label length idiom, indexing
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.4.2 (String Representation)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_14_string_bytes.lst ch03_14_string_bytes.asm && ld -g -o ch03_14_string_bytes ch03_14_string_bytes.o
; Run:    ./ch03_14_string_bytes ; echo $?        -> exit code: 72
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    strng       db  "Hi"                    ; two bytes: 'H' (72), 'i' (105)
    len         equ $ - strng               ; $ = current offset, so len = 2

section .text
global _start
_start:

    movzx   rdi, byte [strng]               ; first byte of the string: 'H' = 72

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
