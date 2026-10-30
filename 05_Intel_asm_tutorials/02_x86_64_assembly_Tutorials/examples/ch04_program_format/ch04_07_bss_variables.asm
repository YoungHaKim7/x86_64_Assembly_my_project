; -----------------------------------------------------------------------------
; Reserving space in the bss section
;
; Demonstrates: resb/resw/resd/resq (no initial values, zeroed at load time)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.5 (BSS Section)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_07_bss_variables.lst ch04_07_bss_variables.asm && ld -g -o ch04_07_bss_variables ch04_07_bss_variables.o
; Run:    ./ch04_07_bss_variables ; echo $?        -> exit code: 51
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .bss
    bVar1       resb 1                       ; reserve 1 byte   (1 byte in memory)
    wVar1       resw 1                       ; reserve 1 word   (2 bytes in memory)
    dVar1       resd 1                       ; reserve 1 dword  (4 bytes in memory)
    qVar1       resq 1                       ; reserve 1 qword  (8 bytes in memory)

section .text
global _start
_start:

    mov     rax, 17                          ; rax = 17
    add     rax, 17                          ; rax = 34
    add     rax, 17                          ; rax = 51 = 17 * 3

    mov     qword [qVar1], rax               ; store into the reserved qword
    mov     rdi, qword [qVar1]               ; read it back (51)

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
