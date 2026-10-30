; -----------------------------------------------------------------------------
; movss -- loading a 32-bit float into an XMM register
;
; Demonstrates: movss memory->xmm, comiss comparison
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.3 (Data Movement)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_02.lst ch18_02_movss_load.asm && ld -g -o ch18_02_movss_load ch18_02_movss_load.o
; Run:    ./ch18_02_movss_load ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltVal      dd  2.5

section .text
global _start
_start:
    movss   xmm0, dword [fltVal]       ; load the float
    movss   xmm1, xmm0                 ; copy it (register to register)
    comiss  xmm0, xmm1                 ; compare: equal?
    je      equal                       ; ZF=1, CF=0 -> identical bits

    mov     rax, 0                      ; not equal (should not happen)
    jmp     last
equal:
    mov     rax, 1                      ; the loaded value matches itself

last:
    mov     rdi, rax                    ; exit status = 1
    mov     rax, SYS_exit
    syscall
