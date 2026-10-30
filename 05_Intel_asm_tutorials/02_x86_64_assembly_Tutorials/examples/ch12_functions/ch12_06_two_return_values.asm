; -----------------------------------------------------------------------------
; Function returning two values (rax and rdx)
;
; Demonstrates: unsigned div producing quotient and remainder, primary
;               result in rax, secondary result in rdx
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.8.2 (Register Usage)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_06_two_return_values.lst ch12_06_two_return_values.asm && ld -g -o ch12_06_two_return_values ch12_06_two_return_values.o
; Run:    ./ch12_06_two_return_values ; echo $?        -> exit code: 2
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; divMod -- rdi = dividend, rsi = divisor.
; Returns: rax = quotient, rdx = remainder.
; The convention fixes rax for the primary return value; a second value is
; conventionally delivered in rdx (exactly where div leaves it anyway).
divMod:
    mov     rax, rdi                    ; rax = dividend
    xor     rdx, rdx                    ; rdx must be 0 before unsigned div
    div     rsi                         ; rax = rdi/rsi, rdx = rdi mod rsi
    ret

_start:
    mov     rdi, 47                     ; dividend
    mov     rsi, 9                      ; divisor
    call    divMod                      ; rax = 5 (quotient), rdx = 2 (rem)

    ; Verify the pair: quotient * divisor + remainder must equal 47.
    mov     rcx, rax                    ; rcx = quotient (5)
    imul    rcx, rsi                    ; rcx = 5 * 9 = 45
    add     rcx, rdx                    ; rcx = 45 + 2 = 47 (dividend back)
    sub     rcx, rdi                    ; rcx = 0 only if the math is right

    ; Exit status = the secondary return value (remainder), plus the zero
    ; check result: 2 + 0 = 2.
    lea     rdi, [rdx + rcx]            ; rdi = 2 + 0 = 2

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall
