; -----------------------------------------------------------------------------
; Unsigned comparison: jb (jump if below)
;
; Demonstrates: cmp + jb — unsigned "less than" (CF = 1)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_118.lst ch07_118_unsigned_jb.asm && ld -g -o ch07_118 ch07_118_unsigned_jb.o
; Run:    ./ch07_118 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 3                  ; small unsigned value
    dVar2       dd 254                ; larger unsigned value

section .text
global _start
_start:

; jb ("jump if below") performs an UNSIGNED comparison: it tests the carry
; flag CF, which cmp sets when the left operand would need a "borrow".
; Think "below/above" (unsigned) versus "less/greater" (signed).
    mov     eax, dword [dVar1]      ; eax = 3
    mov     edx, dword [dVar2]      ; edx = 254
    mov     ebx, 0                  ; result if the jump is not taken
    cmp     eax, edx                ; unsigned compare: 3 vs 254 -> CF = 1
    jb      wasBelow                ; taken: 3 is below 254
    jmp     last                    ; (skipped by the jb)

wasBelow:
    mov     ebx, 1                  ; report that jb fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
