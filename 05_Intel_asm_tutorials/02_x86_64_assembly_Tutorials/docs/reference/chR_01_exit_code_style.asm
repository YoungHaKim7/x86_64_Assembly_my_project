; -----------------------------------------------------------------------------
; Reference example: exit-code style (numeric verification)
;
; Demonstrates: basic data declarations, mov, add, result via exit code
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.7 (Example Program)
;
; Build:  yasm -f elf64 -g dwarf2 -l chR_01.lst chR_01_exit_code_style.asm && ld -g -o chR_01 chR_01_exit_code_style.o
; Run:    ./chR_01 ; echo $?        -> exit code: 42
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar1       dq 1250000000          ; first quadword operand
    qVar2       dq 900000              ; second quadword operand

section .bss
    qResult     resq 1                 ; room for the quadword result

section .text
global _start
_start:

; qResult = qVar1 / qVar2 + 42   (1250000000 / 900000 = 1388, +42 = 1430)
; exit status keeps only the low 8 bits -> design the demo to use small values:
    mov     rax, 100                   ; rax = 100
    mov     rbx, -58                   ; rbx = -58 (signed)
    add     rax, rbx                   ; rax = 42
    mov     qword [qResult], rax       ; store full result in memory

    mov     rax, 8                     ; also show a size calculation
    mov     rcx, 34                    ; rcx = 34
    add     rcx, rax                   ; rcx = 42 (unchanged answer)

last:
    mov     rax, SYS_exit              ; call code for exit
    mov     rdi, rcx                   ; exit with the computed result (42)
    syscall
