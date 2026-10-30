; -----------------------------------------------------------------------------
; cmp + jne: jump when two values differ
;
; Demonstrates: cmp + jne (ZF = 0)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_114.lst ch07_114_cmp_jne.asm && ld -g -o ch07_114 ch07_114_cmp_jne.o
; Run:    ./ch07_114 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 41                  ; first value
    dVar2       dd 42                  ; second value (different!)

section .text
global _start
_start:

; 41 - 42 = -1, which is non-zero, so cmp clears ZF and jne
; ("jump if not equal") is taken.  jnz is just another name for jne.
    mov     eax, dword [dVar1]      ; eax = 41
    mov     edx, dword [dVar2]      ; edx = 42
    mov     ebx, 0                  ; result if the jump is not taken
    cmp     eax, edx                ; 41 vs 42 -> ZF = 0
    jne     notEqual                ; taken: the values differ
    jmp     last                    ; (skipped by the jne)

notEqual:
    mov     ebx, 1                  ; report that jne fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
