; -----------------------------------------------------------------------------
; movsd -- loading a 64-bit double into an XMM register
;
; Demonstrates: movsd memory->xmm, comisd comparison
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.3 (Data Movement)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_03.lst ch18_03_movsd_load.asm && ld -g -o ch18_03_movsd_load ch18_03_movsd_load.o
; Run:    ./ch18_03_movsd_load ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dblVal      dq  3.25

section .text
global _start
_start:
    movsd   xmm0, qword [dblVal]       ; load the double
    movsd   xmm1, xmm0
    comisd  xmm0, xmm1                 ; double compare, ZF set when equal
    jne     notEqual

    mov     rax, 1
    jmp     last
notEqual:
    xor     rax, rax

last:
    mov     rdi, rax                    ; exit status = 1
    mov     rax, SYS_exit
    syscall
