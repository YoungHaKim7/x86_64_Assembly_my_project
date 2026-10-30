; -----------------------------------------------------------------------------
; Output plus a meaningful exit code
;
; Demonstrates: SYS_write followed by SYS_exit with a chosen status
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.1 and 23.1 (Return Codes)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_05.lst ch13_05_exit_code_demo.asm && ld -g -o ch13_05_exit_code_demo ch13_05_exit_code_demo.o
; Run:    ./ch13_05_exit_code_demo ; echo $?
;         -> A            (stdout)
;            65           (exit status: the character code printed)
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
STDOUT           equ 1

section .data
    msg         db  "A", 10
    msgLen      equ $-msg

section .text
global _start
_start:
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, msg
    mov     rdx, msgLen
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, 65                    ; exit with 'A' = 65
    syscall
