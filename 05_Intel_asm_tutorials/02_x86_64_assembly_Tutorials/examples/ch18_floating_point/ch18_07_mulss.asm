; -----------------------------------------------------------------------------
; mulss -- single-precision multiplication
;
; Demonstrates: mulss
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_07.lst ch18_07_mulss.asm && ld -g -o ch18_07_mulss ch18_07_mulss.o
; Run:    ./ch18_07_mulss ; echo $?        -> exit code: 10
;
; 2.5 * 4.0 = 10.0 exactly.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltA        dd  2.5
    fltB        dd  4.0

section .text
global _start
_start:
    movss   xmm0, dword [fltA]
    mulss   xmm0, dword [fltB]         ; xmm0 = 10.0f
    cvttss2si rax, xmm0                ; 10

last:
    mov     rdi, rax                    ; exit status = 10
    mov     rax, SYS_exit
    syscall
