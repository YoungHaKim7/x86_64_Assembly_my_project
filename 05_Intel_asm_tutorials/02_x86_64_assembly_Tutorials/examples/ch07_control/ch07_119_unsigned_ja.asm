; -----------------------------------------------------------------------------
; Unsigned comparison: ja (jump if above)
;
; Demonstrates: cmp + ja — unsigned "greater than" (CF = 0 and ZF = 0)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_119.lst ch07_119_unsigned_ja.asm && ld -g -o ch07_119 ch07_119_unsigned_ja.o
; Run:    ./ch07_119 ; echo $?       -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 254                ; larger unsigned value
    dVar2       dd 3                  ; smaller unsigned value

section .text
global _start
_start:

; ja ("jump if above") is the unsigned twin of jg: it fires when CF = 0
; (no borrow) AND ZF = 0 (not equal), i.e. the left operand is strictly
; greater as an unsigned integer.  254 > 3 -> taken.
    mov     eax, dword [dVar1]      ; eax = 254
    mov     edx, dword [dVar2]      ; edx = 3
    mov     ebx, 0                  ; result if the jump is not taken
    cmp     eax, edx                ; unsigned compare: 254 vs 3
    ja      wasAbove                ; taken: 254 is above 3
    jmp     last                    ; (skipped by the ja)

wasAbove:
    mov     ebx, 1                  ; report that ja fired

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = 1
    syscall
