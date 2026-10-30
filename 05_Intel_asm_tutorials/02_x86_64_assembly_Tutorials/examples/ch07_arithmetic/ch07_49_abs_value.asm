; -----------------------------------------------------------------------------
; abs: absolute value of a qword via neg (-77 -> 77)
;
; Demonstrates: sign test (js) combined with neg to compute abs()
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_49_abs_value.lst ch07_49_abs_value.asm && ld -g -o ch07_49_abs_value ch07_49_abs_value.o
; Run:    ./ch07_49_abs_value ; echo $?        -> exit code: 77
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar1       dq -77                    ; negative qword operand

section .text
global _start
_start:

; classic abs(rax) idiom: inspect the sign, negate only when negative
    mov     rax, qword [qVar1]            ; rax = -77
    cmp     rax, 0                        ; compare against zero (sets SF)
    jns     done                          ; sign clear -> already positive
    neg     rax                           ; negative -> flip sign: rax = 77

done:
; rax = |qVar1| = 77, well inside the exit-code range
    mov     rdi, rax                      ; exit code 77

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
