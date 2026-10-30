; -----------------------------------------------------------------------------
; Euclid's GCD algorithm: gcd(252, 105) = 21
;
; Demonstrates: div (for the modulo) inside a while-style loop,
;               register moves to swap values
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_77.lst ch07_77_gcd_euclid.asm && ld -g -o ch07_77 ch07_77_gcd_euclid.o
; Run:    ./ch07_77 ; echo $?        -> exit code: 21
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qA          dq 252                  ; first value
    qB          dq 105                  ; second value

section .text
global _start
_start:

; while (b != 0)  { (a, b) = (b, a mod b); }  answer in a.
; Trace: (252,105) -> (105,42) -> (42,21) -> (21,0) -> gcd = 21.
    mov     rax, qword [qA]             ; rax = a = 252
    mov     rbx, qword [qB]             ; rbx = b = 105

gcdLoop:
    cmp     rbx, 0                      ; b == 0 -> done
    je      gcdDone
    mov     rcx, rbx                    ; rcx = b (saved for the swap)
    xor     rdx, rdx                    ; rdx = 0 (high half of dividend)
    div     rbx                         ; rdx = a mod b
    mov     rax, rcx                    ; a = old b
    mov     rbx, rdx                    ; b = a mod b
    jmp     gcdLoop

gcdDone:
; rax = gcd(252, 105) = 3 * 7 = 21.
    movzx   edi, al                     ; exit status = 21

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (21)
