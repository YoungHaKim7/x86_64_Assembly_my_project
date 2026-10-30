; -----------------------------------------------------------------------------
; cmp + je: jump when two values are equal
;
; Demonstrates: cmp (subtraction that only sets flags), je (ZF = 1)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_113.lst ch07_113_cmp_je.asm && ld -g -o ch07_113 ch07_113_cmp_je.o
; Run:    ./ch07_113 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 42                  ; first value
    dVar2       dd 42                  ; second value (equal!)

section .text
global _start
_start:

; cmp subtracts its right operand from its left, throws the result away,
; and keeps only the rFLAGS bits.  42 - 42 = 0, so ZF = 1 and
; je ("jump if equal") is taken.  jz is just another name for je.
    mov     eax, dword [dVar1]      ; eax = 42
    mov     edx, dword [dVar2]      ; edx = 42
    mov     ebx, 0                  ; result if the jump is not taken
    cmp     eax, edx                ; 42 vs 42 -> ZF = 1
    je      wasEqual                ; taken: the values are equal
    jmp     last                    ; (skipped by the je)

wasEqual:
    mov     ebx, 1                  ; report that je fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
