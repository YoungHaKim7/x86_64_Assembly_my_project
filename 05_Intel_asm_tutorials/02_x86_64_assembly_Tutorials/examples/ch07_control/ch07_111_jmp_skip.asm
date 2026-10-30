; -----------------------------------------------------------------------------
; Unconditional jmp: hop over an instruction that would change the result
;
; Demonstrates: jmp — the only jump that never tests rFLAGS
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_111.lst ch07_111_jmp_skip.asm && ld -g -o ch07_111 ch07_111_jmp_skip.o
; Run:    ./ch07_111 ; echo $?        -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; rbx is loaded with 5, then jmp transfers control straight past the add.
; Unlike every conditional jump, jmp consults no flag — it is always taken.
    mov     rbx, 5                  ; rbx = 5 (the intended result)
    jmp     skipAdd                 ; unconditional jump over the next line
    add     rbx, 40                 ; skipped by the jmp: rbx would be 45

skipAdd:
; Control resumes here with rbx still 5 — the add was never executed.

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 5
    syscall
