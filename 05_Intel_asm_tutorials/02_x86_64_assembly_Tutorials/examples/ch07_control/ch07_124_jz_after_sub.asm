; -----------------------------------------------------------------------------
; jz: jump when a subtraction produces zero
;
; Demonstrates: sub setting ZF, jz taken (jz and je are the same opcode)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_124.lst ch07_124_jz_after_sub.asm && ld -g -o ch07_124 ch07_124_jz_after_sub.o
; Run:    ./ch07_124 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 50                 ; first value
    dVar2       dd 50                 ; same value

section .text
global _start
_start:

; sub stores its result AND sets flags.  50 - 50 = 0, so ZF = 1 and jz
; ("jump if zero") is taken — the usual way to test "are these equal?"
; after a subtraction instead of a cmp (which is itself a sub).
    mov     eax, dword [dVar1]      ; eax = 50
    mov     ebx, 0                  ; result if the jump is not taken
    sub     eax, dword [dVar2]      ; eax = 0 -> ZF = 1
    jz      wasZero                 ; taken: the difference is zero
    jmp     last                    ; (skipped by the jz)

wasZero:
    mov     ebx, 1                  ; report that jz fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
