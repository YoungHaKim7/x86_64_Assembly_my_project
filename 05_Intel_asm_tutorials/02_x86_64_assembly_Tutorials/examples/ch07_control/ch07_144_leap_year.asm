; -----------------------------------------------------------------------------
; Leap year test -- (div by 4 and not by 100) or (div by 400)
;
; Demonstrates: compound conditions with test/div + jcc chains
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_144.lst ch07_144_leap_year.asm && ld -g -o ch07_144_leap_year ch07_144_leap_year.o
; Run:    ./ch07_144_leap_year ; echo $?        -> exit code: 2
;
; Tests three years and sums the flags: 2024 -> 1, 1900 -> 0, 2000 -> 1.
; A year is leap when divisible by 4 and not by 100, unless it is also
; divisible by 400.  Divisibility is checked with div and a zero test on
; the remainder (rdx).
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start

; rdi = year; returns rax = 1 if leap else 0
isLeap:
    mov     rax, rdi
    xor     rdx, rdx
    mov     rcx, 400
    div     rcx
    test    rdx, rdx                   ; div by 400?
    jz      .leap

    mov     rax, rdi
    xor     rdx, rdx
    mov     rcx, 100
    div     rcx
    test    rdx, rdx                   ; div by 100 but not 400?
    jz      .notLeap

    mov     rax, rdi
    xor     rdx, rdx
    mov     rcx, 4
    div     rcx
    test    rdx, rdx                   ; div by 4?
    jz      .leap

.notLeap:
    xor     rax, rax
    ret
.leap:
    mov     rax, 1
    ret

_start:
    xor     r12, r12                   ; flag accumulator

    mov     rdi, 2024
    call    isLeap
    add     r12, rax                   ; +1

    mov     rdi, 1900
    call    isLeap
    add     r12, rax                   ; +0

    mov     rdi, 2000
    call    isLeap
    add     r12, rax                   ; +1  (r12 = 2)

last:
    mov     rdi, r12                   ; exit status = 2
    mov     rax, SYS_exit
    syscall
