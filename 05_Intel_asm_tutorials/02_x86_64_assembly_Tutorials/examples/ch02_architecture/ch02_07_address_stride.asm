; -----------------------------------------------------------------------------
; Address arithmetic: array elements are sizeof(element) apart
;
; Demonstrates: lea with a displacement, subtracting addresses
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 2.4 (Main Memory)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch02_07_address_stride.lst ch02_07_address_stride.asm && ld -g -o ch02_07_address_stride ch02_07_address_stride.o
; Run:    ./ch02_07_address_stride ; echo $?        -> exit code: 8
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 101, 102, 103            ; qword array: 3 elements, stride 8

section .text
global _start
_start:

    mov     rax, qArr                       ; rax = address of element 0
    lea     rcx, [qArr + 8]                 ; rcx = address of element 1
    sub     rcx, rax                        ; rcx = 8: one qword of address stride

last:
    mov     rdi, rcx                        ; exit code 8
    mov     rax, SYS_exit                   ; call code for exit
    syscall
