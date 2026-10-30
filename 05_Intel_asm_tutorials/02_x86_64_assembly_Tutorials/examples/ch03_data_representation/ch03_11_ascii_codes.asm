; -----------------------------------------------------------------------------
; Characters are small integers: the ASCII code of 'A'
;
; Demonstrates: character constants assemble to their ASCII values
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.4.1.1 (American Standard Code...)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_11_ascii_codes.lst ch03_11_ascii_codes.asm && ld -g -o ch03_11_ascii_codes ch03_11_ascii_codes.o
; Run:    ./ch03_11_ascii_codes ; echo $?        -> exit code: 65
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     al, 'A'                         ; the assembler writes 65 for 'A'

    movzx   rdi, al                         ; exit code 65

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
