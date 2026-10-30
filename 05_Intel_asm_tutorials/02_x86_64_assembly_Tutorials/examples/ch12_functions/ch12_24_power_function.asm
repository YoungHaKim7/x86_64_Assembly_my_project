; -----------------------------------------------------------------------------
; Integer power function (iterative)
;
; Demonstrates: repeated multiplication loop; base parked in callee-saved
;               rbx so the exponent register can double as the loop counter
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.5 (Standard Calling Convention),
;               12.8.2 (Register Usage)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_24_power_function.lst ch12_24_power_function.asm && ld -g -o ch12_24_power_function ch12_24_power_function.o
; Run:    ./ch12_24_power_function ; echo $?        -> exit code: 81
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .text
global _start

; -----------------------------------------------------------------------------
; power -- rdi = base, rsi = exponent (>= 0); returns base^exponent in rax.
;          power(3, 4) = 3*3*3*3 = 81.
power:
    push    rbx                         ; preserve rbx for our caller
    mov     rbx, rdi                    ; rbx = base
    mov     rax, 1                      ; rax = result = 1 (x^0 case too)
.mulLoop:
    test    rsi, rsi                    ; exponent exhausted?
    jz      .done
    imul    rax, rbx                    ; result *= base
    dec     rsi                         ; one fewer multiplication to go
    jmp     .mulLoop
.done:
    pop     rbx
    ret

_start:
    mov     rdi, 3                      ; argument 1: base
    mov     rsi, 4                      ; argument 2: exponent
    call    power                       ; rax = 81

last:
    mov     rdi, rax                    ; exit status = computed result (81)
    mov     rax, SYS_exit               ; call code for exit
    syscall
