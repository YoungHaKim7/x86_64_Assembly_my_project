; -----------------------------------------------------------------------------
; isDigit -- range test for '0'..'9'
;
; Demonstrates: character classification with unsigned comparisons
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_145.lst ch07_145_is_digit.asm && ld -g -o ch07_145_is_digit ch07_145_is_digit.o
; Run:    ./ch07_145_is_digit ; echo $?        -> exit code: 1
;
; '5' is in range (1), 'x' is not (0); the program returns their sum.
; The sub/cmp trick compares against both bounds with unsigned jumps:
; anything below '0' or above '9' wraps and fails jb/ja.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start

; rdi = char; rax = 1 if '0'..'9' else 0
isDigit:
    xor     rax, rax
    cmp     dil, '0'
    jb      .no
    cmp     dil, '9'
    ja      .no
    mov     rax, 1
.no:
    ret

_start:
    xor     r12, r12
    mov     rdi, '5'
    call    isDigit
    add     r12, rax                   ; +1
    mov     rdi, 'x'
    call    isDigit
    add     r12, rax                   ; +0

last:
    mov     rdi, r12                   ; exit status = 1
    mov     rax, SYS_exit
    syscall
