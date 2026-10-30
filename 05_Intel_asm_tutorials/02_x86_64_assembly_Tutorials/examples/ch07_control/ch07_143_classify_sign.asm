; -----------------------------------------------------------------------------
; Sign classification -- negative / zero / positive via test + jcc
;
; Demonstrates: three-way branch on the sign of a value
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_143.lst ch07_143_classify_sign.asm && ld -g -o ch07_143_classify_sign ch07_143_classify_sign.o
; Run:    ./ch07_143_classify_sign ; echo $?        -> exit code: 0
;
; Result code: 0 = negative, 1 = zero, 2 = positive.  Input here is -42.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rbx, -42                   ; the value to classify

    test    rbx, rbx                   ; load sign + zero flags
    jz      .isZero                    ; ZF=1 -> zero
    js      .isNegative                ; SF=1 -> negative
    mov     rax, 2                     ; positive
    jmp     last

.isZero:
    mov     rax, 1
    jmp     last

.isNegative:
    xor     rax, rax                   ; 0 = negative

last:
    mov     rdi, rax                   ; exit status = 0 (negative)
    mov     rax, SYS_exit
    syscall
