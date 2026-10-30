; -----------------------------------------------------------------------------
; lea gives the address, mov gives the value
;
; Demonstrates: the difference between lea reg,[qArr+8] and mov reg,[qArr+8]
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.3
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_17.lst ch07_17_lea_vs_mov_value.asm && ld -g -o ch07_17 ch07_17_lea_vs_mov_value.o
; Run:    ./ch07_17 ; echo $?        -> exit code: 20
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 10, 20, 30        ; qword array: elements 0, 1, 2

section .text
global _start
_start:

; Same bracket expression, two very different results:
    lea     rax, [qArr + 8]          ; rax = ADDRESS of qArr[1] (no load!)
    mov     rbx, qword [qArr + 8]    ; rbx = VALUE   of qArr[1] = 20

; Proof that rax really holds a usable address: dereference it and the
; value comes back out of memory.
    mov     rcx, qword [rax]         ; rcx = 20 as well (via the address)

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 20
    syscall
