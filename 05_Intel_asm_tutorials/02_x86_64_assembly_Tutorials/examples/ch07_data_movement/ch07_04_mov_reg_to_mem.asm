; -----------------------------------------------------------------------------
; Register to memory mov: storing into a .bss variable
;
; Demonstrates: mov qword [label], reg64 — writing a register to memory
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_04.lst ch07_04_mov_reg_to_mem.asm && ld -g -o ch07_04 ch07_04_mov_reg_to_mem.o
; Run:    ./ch07_04 ; echo $?        -> exit code: 88
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .bss
    qAns        resq 1               ; one quadword of uninitialized storage

section .text
global _start
_start:

; .bss variables occupy no space in the file and start as zeroes at
; load time; the program fills them in at run time.
    mov     rax, 88                  ; rax = 88 (value to save)
    mov     qword [qAns], rax        ; qAns = 88 (register -> memory)
    mov     rbx, qword [qAns]        ; read it back: rbx = 88

; The reload proves the store really landed in memory and that rbx now
; holds the same value that was in rax.

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 88
    syscall
