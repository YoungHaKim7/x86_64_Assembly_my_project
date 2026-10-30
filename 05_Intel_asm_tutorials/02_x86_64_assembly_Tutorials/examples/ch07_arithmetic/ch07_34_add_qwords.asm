; -----------------------------------------------------------------------------
; add: quadword addition (1000000000000 + 1)
;
; Demonstrates: add instruction with qword (64-bit) operands
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_34_add_qwords.lst ch07_34_add_qwords.asm && ld -g -o ch07_34_add_qwords ch07_34_add_qwords.o
; Run:    ./ch07_34_add_qwords ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar1       dq 1000000000000           ; one trillion = 0xE8D4A51000
    qVar2       dq 1                       ; small addend

section .bss
    qResult     resq 1                     ; room for the qword result

section .text
global _start
_start:

; qResult = qVar1 + qVar2
; full result: 1000000000001 = 0xE8D4A51001, no carry (fits in 64 bits)
    mov     rax, qword [qVar1]             ; rax = 1000000000000
    add     rax, qword [qVar2]             ; rax = 1000000000001
    mov     qword [qResult], rax           ; store the full 64-bit result

; the shell keeps only the low 8 bits of the exit status. Conveniently,
; 10^12 = 2^12 * 5^12 is a multiple of 256 (low byte 0x00), so after
; adding 1 the low byte is exactly 1 -> exit code 1.
    mov     rdi, qword [qResult]           ; rdi = 1000000000001 -> exit 1

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
