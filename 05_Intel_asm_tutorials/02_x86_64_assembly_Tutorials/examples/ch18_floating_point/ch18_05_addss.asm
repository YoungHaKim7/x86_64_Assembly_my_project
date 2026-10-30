; -----------------------------------------------------------------------------
; addss -- single-precision addition
;
; Demonstrates: addss plus conversion back to integer (cvttss2si)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_05.lst ch18_05_addss.asm && ld -g -o ch18_05_addss ch18_05_addss.o
; Run:    ./ch18_05_addss ; echo $?        -> exit code: 3
;
; 1.5 + 2.25 = 3.75; cvttss2si truncates toward zero -> 3.
; 1.5, 2.25 and 3.75 are all exactly representable in binary.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltA        dd  1.5
    fltB        dd  2.25

section .text
global _start
_start:
    movss   xmm0, dword [fltA]
    addss   xmm0, dword [fltB]         ; xmm0 = 3.75f
    cvttss2si rax, xmm0                ; truncate: 3.75 -> 3

last:
    mov     rdi, rax                    ; exit status = 3
    mov     rax, SYS_exit
    syscall
