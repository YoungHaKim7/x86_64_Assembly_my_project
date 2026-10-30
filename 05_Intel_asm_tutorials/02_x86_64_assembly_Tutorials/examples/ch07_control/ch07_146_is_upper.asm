; -----------------------------------------------------------------------------
; isUpper -- range test for 'A'..'Z'
;
; Demonstrates: character classification with unsigned range checks
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_146.lst ch07_146_is_upper.asm && ld -g -o ch07_146_is_upper ch07_146_is_upper.o
; Run:    ./ch07_146_is_upper ; echo $?        -> exit code: 1
;
; 'G' is uppercase (1), 'g' is not (0); returns the sum.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start

; rdi = char; rax = 1 if 'A'..'Z' else 0
isUpper:
    xor     rax, rax
    cmp     dil, 'A'
    jb      .no
    cmp     dil, 'Z'
    ja      .no
    mov     rax, 1
.no:
    ret

_start:
    xor     r12, r12
    mov     rdi, 'G'
    call    isUpper
    add     r12, rax                   ; +1
    mov     rdi, 'g'
    call    isUpper
    add     r12, rax                   ; +0

last:
    mov     rdi, r12                   ; exit status = 1
    mov     rax, SYS_exit
    syscall
