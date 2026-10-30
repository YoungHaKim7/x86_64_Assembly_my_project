; -----------------------------------------------------------------------------
; isLower -- range test for 'a'..'z'
;
; Demonstrates: character classification with unsigned range checks
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_147.lst ch07_147_is_lower.asm && ld -g -o ch07_147_is_lower ch07_147_is_lower.o
; Run:    ./ch07_147_is_lower ; echo $?        -> exit code: 1
;
; 'q' is lowercase (1), 'Q' is not (0); returns the sum.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start

; rdi = char; rax = 1 if 'a'..'z' else 0
isLower:
    xor     rax, rax
    cmp     dil, 'a'
    jb      .no
    cmp     dil, 'z'
    ja      .no
    mov     rax, 1
.no:
    ret

_start:
    xor     r12, r12
    mov     rdi, 'q'
    call    isLower
    add     r12, rax                   ; +1
    mov     rdi, 'Q'
    call    isLower
    add     r12, rax                   ; +0

last:
    mov     rdi, r12                   ; exit status = 1
    mov     rax, SYS_exit
    syscall
