; -----------------------------------------------------------------------------
; ASCII case conversion: 'A' + 32 == 'a'
;
; Demonstrates: arithmetic on character codes flips the case bit
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.4.1.1 (American Standard Code...)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_12_ascii_case.lst ch03_12_ascii_case.asm && ld -g -o ch03_12_ascii_case ch03_12_ascii_case.o
; Run:    ./ch03_12_ascii_case ; echo $?        -> exit code: 97
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     al, 'A'                         ; al = 65
    add     al, 32                          ; 65 + 32 = 97: bit 5 turns 'A' into 'a'

    movzx   rdi, al                         ; exit code 97 ('a')

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
