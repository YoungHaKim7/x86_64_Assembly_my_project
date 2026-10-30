; -----------------------------------------------------------------------------
; sqrtss -- square root, single precision
;
; Demonstrates: sqrtss (hardware square root, no library call)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_09.lst ch18_09_sqrtss.asm && ld -g -o ch18_09_sqrtss ch18_09_sqrtss.o
; Run:    ./ch18_09_sqrtss ; echo $?        -> exit code: 12
;
; sqrt(144.0) = 12.0 exactly.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltA        dd  144.0

section .text
global _start
_start:
    sqrtss  xmm0, dword [fltA]         ; xmm0 = 12.0f
    cvttss2si rax, xmm0                ; 12

last:
    mov     rdi, rax                    ; exit status = 12
    mov     rax, SYS_exit
    syscall
