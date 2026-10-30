; -----------------------------------------------------------------------------
; .bss memory arrives zero-filled
;
; Demonstrates: resq reserves uninitialized space; the loader gives zeroes
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 2.5 (Memory Layout)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch02_06_bss_is_zero.lst ch02_06_bss_is_zero.asm && ld -g -o ch02_06_bss_is_zero ch02_06_bss_is_zero.o
; Run:    ./ch02_06_bss_is_zero ; echo $?        -> exit code: 21
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .bss
    qVar1       resq 1                      ; uninitialized qword (no file space used)

section .text
global _start
_start:

    mov     rax, qword [qVar1]              ; reads 0: .bss pages start zeroed
    add     rax, 21                         ; 0 + 21 = 21

last:
    mov     rdi, rax                        ; exit code 21
    mov     rax, SYS_exit                   ; call code for exit
    syscall
