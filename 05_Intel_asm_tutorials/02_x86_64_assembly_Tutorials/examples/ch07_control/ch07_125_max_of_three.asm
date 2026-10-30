; -----------------------------------------------------------------------------
; Largest of three values with a cmp/jle chain
;
; Demonstrates: conditional jumps building a running maximum
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_125.lst ch07_125_max_of_three.asm && ld -g -o ch07_125 ch07_125_max_of_three.o
; Run:    ./ch07_125 ; echo $?       -> exit code: 45
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 12                 ; candidate 1
    dVar2       dd 45                 ; candidate 2 (the winner)
    dVar3       dd 23                 ; candidate 3

section .text
global _start
_start:

; Keep a "running maximum" in eax.  Each candidate is compared against it;
; jle skips the update when the candidate is "less or equal", i.e. cannot
; be the new maximum.
    mov     eax, dword [dVar1]      ; running max = 12
    mov     edx, dword [dVar2]      ; candidate = 45
    cmp     edx, eax                ; 45 vs 12 (signed)
    jle     tryThird                ; 45 <= 12? no -> take the fall-through
    mov     eax, edx                ; running max = 45

tryThird:
    mov     edx, dword [dVar3]      ; candidate = 23
    cmp     edx, eax                ; 23 vs 45 (signed)
    jle     done                    ; 23 <= 45? yes -> keep 45
    mov     eax, edx                ; (not reached: 23 is not the max)

done:
    mov     ebx, eax                ; result = max(12, 45, 23) = 45

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 45
    syscall
