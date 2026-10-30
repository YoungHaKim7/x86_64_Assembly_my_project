; -----------------------------------------------------------------------------
; Greatest common divisor (Euclidean algorithm)
;
; Demonstrates: an in-place iterative function that is free to modify its
;               own caller-saved argument registers (rdi, rsi)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.5 (Standard Calling Convention)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_25_gcd_function.lst ch12_25_gcd_function.asm && ld -g -o ch12_25_gcd_function ch12_25_gcd_function.o
; Run:    ./ch12_25_gcd_function ; echo $?        -> exit code: 21
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; gcd -- rdi = a, rsi = b (both > 0); returns gcd(a, b) in rax.
;
;   while b != 0:  (a, b) = (b, a mod b);  answer = a
;
; The argument registers rdi and rsi are caller-saved, so the function may
; reuse them as its working variables -- no callee-saved register needed.
gcd:
    test    rsi, rsi                    ; b == 0?
    jz      .done
    mov     rax, rdi
    xor     rdx, rdx                    ; rdx = 0 before unsigned division
    div     rsi                         ; rax = a/b, rdx = a mod b
    mov     rdi, rsi                    ; a = b
    mov     rsi, rdx                    ; b = a mod b
    jmp     gcd                         ; tail-iterate the same logic
.done:
    mov     rax, rdi                    ; result = a
    ret

_start:
    mov     rdi, 1071                   ; argument 1
    mov     rsi, 462                    ; argument 2
    call    gcd                         ; rax = 21 (1071 = 21*51, 462 = 21*22)

last:
    mov     rdi, rax                    ; exit status = computed result (21)
    mov     rax, SYS_exit               ; call code for exit
    syscall
