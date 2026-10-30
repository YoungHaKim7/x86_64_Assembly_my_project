; -----------------------------------------------------------------------------
; SHR as unsigned divide-by-4: 100 shr 2 = 25
;
; Demonstrates: shr instruction as a fast unsigned division by a power of 2
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_98.lst ch07_98_shr_divide_4.asm && ld -g -o ch07_98 ch07_98_shr_divide_4.o
; Run:    ./ch07_98 ; echo $?        -> exit code: 25
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Each position shifted right halves an unsigned value, so shr 2 divides
; by 4: 100 = 0110 0100 -> 0001 1001 = 25.
    mov     al, 100                     ; al = 100
    shr     al, 2                       ; al = 25 (100 / 2^2)
    mov     bl, al                      ; bl = 25 (shr result kept)

; Cross-check with a real unsigned divide (byte form: ax / cl).
    mov     ax, 100                     ; ax = 100, ah = 0 as div requires
    mov     cl, 4                       ; divisor 4 = 2^2
    div     cl                          ; al = 25 quotient, ah = 0 remainder
    mov     edi, EXIT_SUCCESS           ; status 0 if the results differ
    cmp     al, bl                      ; div result vs shr result
    jne     last                        ; mismatch (never taken here)
    movzx   edi, al                     ; agree: exit with 25

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (25)
