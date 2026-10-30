; -----------------------------------------------------------------------------
; Sum of decimal digits -- div-by-10 loop peeling digits
;
; Demonstrates: division loop producing digits least-significant first
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_154.lst ch07_154_sum_digits.asm && ld -g -o ch07_154_sum_digits ch07_154_sum_digits.o
; Run:    ./ch07_154_sum_digits ; echo $?        -> exit code: 11
;
; 407 -> 4 + 0 + 7 = 11.  The same loop shape powers itoa (ch13_11).
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rax, 407                   ; number to process
    xor     rbx, rbx                   ; digit sum = 0

.digitLoop:
    xor     rdx, rdx                   ; rdx:rax = value
    mov     rcx, 10
    div     rcx                        ; rax = value/10, rdx = digit
    add     rbx, rdx                   ; accumulate digit
    test    rax, rax
    jnz     .digitLoop                 ; more digits remain
    ; rbx = 11

last:
    mov     rdi, rbx                   ; exit status = 11
    mov     rax, SYS_exit
    syscall
