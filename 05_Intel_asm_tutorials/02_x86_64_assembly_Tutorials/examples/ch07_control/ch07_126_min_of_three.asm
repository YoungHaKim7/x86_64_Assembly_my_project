; -----------------------------------------------------------------------------
; Smallest of three values with a cmp/jge chain
;
; Demonstrates: conditional jumps building a running minimum
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_126.lst ch07_126_min_of_three.asm && ld -g -o ch07_126 ch07_126_min_of_three.o
; Run:    ./ch07_126 ; echo $?       -> exit code: 12
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 12                 ; candidate 1 (the winner)
    dVar2       dd 45                 ; candidate 2
    dVar3       dd 23                 ; candidate 3

section .text
global _start
_start:

; Mirror image of the running-maximum chain: jge skips the update when the
; candidate is "greater or equal", i.e. cannot be the new minimum.
    mov     eax, dword [dVar1]      ; running min = 12
    mov     edx, dword [dVar2]      ; candidate = 45
    cmp     edx, eax                ; 45 vs 12 (signed)
    jge     tryThird                ; 45 >= 12? yes -> keep 12
    mov     eax, edx                ; (not reached: 45 is not the min)

tryThird:
    mov     edx, dword [dVar3]      ; candidate = 23
    cmp     edx, eax                ; 23 vs 12 (signed)
    jge     done                    ; 23 >= 12? yes -> keep 12
    mov     eax, edx                ; (not reached: 23 is not the min)

done:
    mov     ebx, eax                ; result = min(12, 45, 23) = 12

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 12
    syscall
