; -----------------------------------------------------------------------------
; No memory-to-memory mov: values must travel through a register
;
; Demonstrates: why mov [mem],[mem] is illegal; the register round-trip
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.2
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_06.lst ch07_06_mov_imm_to_mem.asm && ld -g -o ch07_06 ch07_06_mov_imm_to_mem.o
; Run:    ./ch07_06 ; echo $?        -> exit code: 91
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qValue      dq 91                ; source value that lives in memory

section .bss
    qAns        resq 1               ; destination quadword (.bss)

section .text
global _start
_start:

; The x86-64 mov has NO memory-to-memory form — at most one operand of a
; mov may be a memory location.  This line would NOT assemble:
;
;       mov     qword [qAns], qword [qValue]    ; <== illegal!
;
; Instead the value must travel through a register in two steps:
    mov     rax, qword [qValue]      ; step 1: memory -> register (rax = 91)
    mov     qword [qAns], rax        ; step 2: register -> memory (qAns = 91)

    mov     rbx, qword [qAns]        ; step 3: reload to prove it (rbx = 91)

last:
    mov     rax, SYS_exit            ; call code for exit
    mov     rdi, rbx                 ; exit status = rbx = 91
    syscall
