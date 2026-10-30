; -----------------------------------------------------------------------------
; Number bases in source code: hex, octal, decimal
;
; Demonstrates: 0x prefix, q suffix, and plain decimal literals
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.2 (Numeric Values)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_12_number_bases.lst ch04_12_number_bases.asm && ld -g -o ch04_12_number_bases ch04_12_number_bases.o
; Run:    ./ch04_12_number_bases ; echo $?        -> exit code: 34
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     al, 0x10                         ; hexadecimal 0x10 = 16
    add     al, 10q                          ; octal       10q  = 8   -> 24
    add     al, 10                           ; decimal     10    = 10  -> 34

    movzx   rdi, al                          ; exit code 34

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
