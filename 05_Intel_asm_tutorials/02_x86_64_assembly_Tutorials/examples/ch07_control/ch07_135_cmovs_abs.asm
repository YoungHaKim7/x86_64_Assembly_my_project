; -----------------------------------------------------------------------------
; cmovs / cmovns -- branchless absolute value
;
; Demonstrates: cmovs (sign flag) selecting the negated copy
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_135.lst ch07_135_cmovs_abs.asm && ld -g -o ch07_135_cmovs_abs ch07_135_cmovs_abs.o
; Run:    ./ch07_135_cmovs_abs ; echo $?        -> exit code: 9
;
; Both the value and its negation are prepared; cmovs picks -x when x is
; negative (SF set by the test), otherwise x itself is kept.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, -9                    ; the value
    mov     rbx, rax                   ; copy
    neg     rbx                        ; rbx = +9
    test    rax, rax                   ; set SF from rax's sign
    cmovs   rax, rbx                   ; negative -> take the negated copy
    ; rax = |-9| = 9

last:
    mov     rdi, rax                   ; exit status = 9
    mov     rax, SYS_exit
    syscall
