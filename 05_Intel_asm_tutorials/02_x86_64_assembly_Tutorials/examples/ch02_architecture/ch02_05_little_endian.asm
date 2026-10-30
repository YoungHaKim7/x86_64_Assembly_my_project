; -----------------------------------------------------------------------------
; x86-64 memory is little-endian
;
; Demonstrates: the least-significant byte sits at the lowest address
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 2.4 (Main Memory)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch02_05_little_endian.lst ch02_05_little_endian.asm && ld -g -o ch02_05_little_endian ch02_05_little_endian.o
; Run:    ./ch02_05_little_endian ; echo $?        -> exit code: 136
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar1       dq 0x1122334455667788       ; memory image (low addr first):
                                            ;   88 77 66 55 44 33 22 11

section .text
global _start
_start:

    mov     rax, qword [qVar1]              ; load the full qword
    movzx   rdi, al                         ; al = byte at the lowest address

; rdi = 0x88 = 136: the low byte of the value lives at the low address
last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
