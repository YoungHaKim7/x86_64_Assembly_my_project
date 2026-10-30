; -----------------------------------------------------------------------------
; cmove -- conditional move on equal (select a default when values match)
;
; Demonstrates: cmove (cmovz) as a branchless selector
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_134.lst ch07_134_cmove_equal.asm && ld -g -o ch07_134_cmove_equal ch07_134_cmove_equal.o
; Run:    ./ch07_134_cmove_equal ; echo $?        -> exit code: 77
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, 42                    ; rax = normal result
    mov     rbx, 77                    ; rbx = substitute value
    mov     rcx, 42                    ; the value to compare against
    cmp     rax, rcx                   ; normal result == expected?
    cmove   rax, rbx                   ; equal -> swap in substitute
    ; rax = 77 because 42 == 42

last:
    mov     rdi, rax                   ; exit status = 77
    mov     rax, SYS_exit
    syscall
