; -----------------------------------------------------------------------------
; Equal values satisfy BOTH jge and jle
;
; Demonstrates: cmp + jge and jle on equal operands — the "or equal" edges
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_117.lst ch07_117_signed_jle_jge.asm && ld -g -o ch07_117 ch07_117_signed_jle_jge.o
; Run:    ./ch07_117 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 7                  ; first value
    dVar2       dd 7                  ; second value (equal!)

section .text
global _start
_start:

; With equal operands, ZF = 1 and SF = OF, so every "or equal" signed jump
; (jge, jle, jnge->jl fails, jnle->jg fails) sees its condition as true.
; Both jumps below are taken; the program exits 1 only if BOTH fired.
    mov     eax, dword [dVar1]      ; eax = 7
    mov     edx, dword [dVar2]      ; edx = 7
    mov     ebx, 0                  ; stays 0 unless both jumps are taken

; check 1: jge — "greater or equal"; 7 >= 7 is true
    cmp     eax, edx                ; 7 vs 7
    jge     checkJle                ; taken
    jmp     last                    ; (guard: exit 0 if jge failed)

checkJle:
; check 2: jle — "less or equal"; 7 <= 7 is also true
    cmp     eax, edx                ; 7 vs 7 again
    jle     bothTaken               ; taken
    jmp     last                    ; (guard: exit 0 if jle failed)

bothTaken:
    mov     ebx, 1                  ; equality satisfies both directions

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
