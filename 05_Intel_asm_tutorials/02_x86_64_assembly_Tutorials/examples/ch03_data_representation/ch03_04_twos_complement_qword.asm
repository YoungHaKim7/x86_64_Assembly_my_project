; -----------------------------------------------------------------------------
; Two's complement negate of a qword sets the sign flag
;
; Demonstrates: neg r64, js (jump if signed / SF = 1)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.1.1 (Two's Complement)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_04_twos_complement_qword.lst ch03_04_twos_complement_qword.asm && ld -g -o ch03_04_twos_complement_qword ch03_04_twos_complement_qword.o
; Run:    ./ch03_04_twos_complement_qword ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar1       dq 128                      ; positive qword to negate

section .text
global _start
_start:

    mov     rax, qword [qVar1]              ; rax = +128
    neg     rax                             ; rax = -128 = 0xFFFFFFFFFFFFFF80

    mov     rdi, 0                          ; assume result is not negative
    jns     last                            ; SF = 0 -> non-negative result
    mov     rdi, 1                          ; SF = 1: the qword is now negative

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
