; -----------------------------------------------------------------------------
; Qword variables in the data section
;
; Demonstrates: dq declaration, qword load/add, keeping the low 8 bits
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.4 (Data Section)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_05_qword_variables.lst ch04_05_qword_variables.asm && ld -g -o ch04_05_qword_variables ch04_05_qword_variables.o
; Run:    ./ch04_05_qword_variables ; echo $?        -> exit code: 100
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar1       dq 2000000000                ; qword variable (fits easily in 64 bits)

section .text
global _start
_start:

    mov     rax, qword [qVar1]               ; rax = 2000000000 (0x77359400)
    add     rax, 100                         ; rax = 2000000100 (full result)

    and     rax, 0xFF                        ; 2000000000 mod 256 = 0, so low byte = 100

    movzx   rdi, al                          ; exit code 100

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
