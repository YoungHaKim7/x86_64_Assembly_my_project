; -----------------------------------------------------------------------------
; Modulo a power of two: 100 mod 16 via AND (100 and 0xF = 4)
;
; Demonstrates: replacing div for mod 2^k with an and against 2^k - 1,
;               cross-checked against a real divide
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_73.lst ch07_73_modulo_power_of_two.asm && ld -g -o ch07_73 ch07_73_modulo_power_of_two.o
; Run:    ./ch07_73 ; echo $?        -> exit code: 4
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; x mod 2^k keeps only the low k bits of x, which is exactly what
; "and x, 2^k - 1" computes -- no divide instruction needed.
    mov     rax, 100                    ; rax = 100
    mov     rcx, rax                    ; keep a copy for the div check
    and     rcx, 15                     ; rcx = 100 mod 16 = 4 (15 = 2^4 - 1)

; Cross-check with a genuine unsigned divide (remainder in rdx):
    xor     rdx, rdx                    ; clear high dividend half
    mov     rbx, 16                     ; divisor 16 = 2^4
    div     rbx                         ; rdx = 100 % 16 = 4

; Both methods must produce the same remainder.
    mov     edi, EXIT_SUCCESS           ; status 0 if they disagree
    cmp     rcx, rdx                    ; and-mask result vs div remainder
    jne     last                        ; mismatch (never taken here)

    movzx   edi, cl                     ; agree: exit with 4

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (4)
