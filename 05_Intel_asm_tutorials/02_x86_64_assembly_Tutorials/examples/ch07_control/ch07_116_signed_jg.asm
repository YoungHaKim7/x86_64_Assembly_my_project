; -----------------------------------------------------------------------------
; Signed comparison: jg (jump if greater)
;
; Demonstrates: cmp + jg — signed "greater than" (ZF = 0 and SF = OF)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_116.lst ch07_116_signed_jg.asm && ld -g -o ch07_116 ch07_116_signed_jg.o
; Run:    ./ch07_116 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 10                 ; larger signed value
    dVar2       dd 3                  ; smaller signed value

section .text
global _start
_start:

; jg ("jump if greater") is the signed twin of ja: it fires when ZF = 0
; (not equal) AND SF = OF (no sign flip relative to overflow), i.e. when the
; left operand is strictly greater as a signed integer.  10 > 3 -> taken.
    mov     eax, dword [dVar1]      ; eax = 10
    mov     edx, dword [dVar2]      ; edx = 3
    mov     ebx, 0                  ; result if the jump is not taken
    cmp     eax, edx                ; signed compare: 10 vs 3
    jg      wasGreater              ; taken: 10 > 3
    jmp     last                    ; (skipped by the jg)

wasGreater:
    mov     ebx, 1                  ; report that jg fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
