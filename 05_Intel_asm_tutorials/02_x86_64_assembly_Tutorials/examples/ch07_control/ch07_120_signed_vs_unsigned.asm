; -----------------------------------------------------------------------------
; The SAME bits, two different orders: signed vs unsigned jumps
;
; Demonstrates: cmp -1,1 — jl (signed) and ja (unsigned) BOTH take
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_120.lst ch07_120_signed_vs_unsigned.asm && ld -g -o ch07_120 ch07_120_signed_vs_unsigned.o
; Run:    ./ch07_120 ; echo $?       -> exit code: 2
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd -1                 ; bits 0xFFFFFFFF: signed -1, unsigned 4294967295
    dVar2       dd 1                  ; plain 1

section .text
global _start
_start:

; dVar1 holds 0xFFFFFFFF.  Read as SIGNED it is -1, so -1 < 1 and a signed
; jl would jump.  Read as UNSIGNED it is 4294967295, so it is above 1 and
; an unsigned ja would also jump.  Both orders are "right" — the jump
; instruction chooses the interpretation.  Count how many fire (expect 2).
    mov     eax, dword [dVar1]      ; eax = 0xFFFFFFFF
    mov     edx, dword [dVar2]      ; edx = 1
    xor     ebx, ebx                ; ebx = number of jumps taken

; signed check: use the "jump if NOT less" form (jnl) to skip the inc
    cmp     eax, edx                ; signed: -1 vs 1
    jnl     notLess                 ; "-1 >= 1"? NO -> not taken
    inc     ebx                     ; so the signed jl condition holds: +1
notLess:
; unsigned check: use the "jump if NOT above" form (jna) to skip the inc
    cmp     eax, edx                ; unsigned: 4294967295 vs 1
    jna     notAbove                ; "not above 1"? NO -> not taken
    inc     ebx                     ; so the unsigned ja condition holds: +1
notAbove:
; ebx = 2: the signed and unsigned views of one bit pattern disagree

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 2
    syscall
