; -----------------------------------------------------------------------------
; Signed comparison: jl (jump if less) with a negative operand
;
; Demonstrates: cmp + jl — signed "less than" (SF != OF)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_115.lst ch07_115_signed_jl.asm && ld -g -o ch07_115 ch07_115_signed_jl.o
; Run:    ./ch07_115 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd -5                 ; negative signed value
    dVar2       dd 3                  ; positive signed value

section .text
global _start
_start:

; jl ("jump if less") performs a SIGNED comparison: it looks at the sign and
; overflow flags (taken when SF != OF), not at carry.  The two's-complement
; bits of -5 (0xFFFFFFFB) really do mean "less than" 3 to jl.
    mov     eax, dword [dVar1]      ; eax = -5
    mov     edx, dword [dVar2]      ; edx = 3
    mov     ebx, 0                  ; result if the jump is not taken
    cmp     eax, edx                ; signed compare: -5 vs 3
    jl      wasLess                 ; taken: -5 < 3
    jmp     last                    ; (skipped by the jl)

wasLess:
    mov     ebx, 1                  ; report that jl fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
