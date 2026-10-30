; -----------------------------------------------------------------------------
; Base + index*scale addressing: array access through registers
;
; Demonstrates: mov reg,[base + index*8] — register-indexed qword array
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.3
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_22.lst ch07_22_mem_via_registers.asm && ld -g -o ch07_22 ch07_22_mem_via_registers.o
; Run:    ./ch07_22 ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 5, 10, 15, 20     ; qArr[0..3]

section .text
global _start
_start:

; Set up the two runtime pieces of the address: a base pointer and an
; element index (the index is a plain integer, NOT a byte offset).
    lea     rbx, [qArr]              ; rbx = base address of the array
    mov     rcx, 2                   ; rcx = element index 2

; The effective address is  rbx + rcx*8  — the CPU scales the index by
; the element size (8 bytes per qword) during the mov, then loads the
; qword found there.  qArr[2] = 15.
    mov     rdx, qword [rbx + rcx*8] ; rdx = 15

; Changing rcx to 0, 1 or 3 would select 5, 10 or 20 — one instruction,
; no reassembly, which is exactly what loops use to walk arrays.

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rdx                 ; exit status = rdx = 15
    syscall
