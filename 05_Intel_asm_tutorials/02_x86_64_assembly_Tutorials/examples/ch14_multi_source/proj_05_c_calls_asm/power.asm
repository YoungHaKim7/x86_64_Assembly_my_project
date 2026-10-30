; -----------------------------------------------------------------------------
; power.asm -- long power(long base, long exp) called FROM C
;
; Demonstrates: assembly honoring the System V calling convention so a
;               C compiler can call it (args in rdi/rsi, result in rax)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 14.3 (Interfacing with a High-Level Language)
;
; Build:  bash build.sh
; Run:    ./proj_05_c_calls_asm
;         -> 2^10 = 1024
; -----------------------------------------------------------------------------

section .text
global power

; power: rdi = base, rsi = exp  ->  rax = base ** exp (exp >= 0)
power:
    push    rbx                        ; we use rbx: callee-saved, must keep
    mov     rax, 1                     ; result accumulator
    mov     rbx, rdi                   ; base
    test    rsi, rsi
    jz      .done
.mulLoop:
    imul    rax, rbx
    dec     rsi
    jnz     .mulLoop
.done:
    pop     rbx
    ret
