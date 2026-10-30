; -----------------------------------------------------------------------------
; Address arithmetic: the byte stride of a qword array
;
; Demonstrates: address differences between array elements (8 bytes/qword)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.3
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_19.lst ch07_19_address_stride.asm && ld -g -o ch07_19 ch07_19_address_stride.o
; Run:    ./ch07_19 ; echo $?        -> exit code: 16
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 5, 10, 15, 20     ; four qwords = 32 bytes total

section .text
global _start
_start:

; Take the addresses of element 0 and element 2 with lea (no memory is
; read — only the addresses are computed):
    lea     rax, [qArr]              ; rax = address of qArr[0]
    lea     rbx, [qArr + 8*2]        ; rbx = address of qArr[2]

; Subtracting two addresses yields the byte distance between them.
; Each element occupies 8 bytes (one qword), so skipping two elements
; moves 2 * 8 = 16 bytes forward in memory.
    sub     rbx, rax                 ; rbx = 16

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 16
    syscall
