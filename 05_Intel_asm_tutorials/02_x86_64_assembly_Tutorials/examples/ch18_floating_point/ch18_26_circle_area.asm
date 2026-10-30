; -----------------------------------------------------------------------------
; Circle area -- pi * r^2 in double precision
;
; Demonstrates: mulsd composition of a formula
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_26.lst ch18_26_circle_area.asm && ld -g -o ch18_26_circle_area ch18_26_circle_area.o
; Run:    ./ch18_26_circle_area ; echo $?        -> exit code: 50
;
; r = 4: pi * 16 = 50.2654824...; truncation reports 50.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    pi          dq  3.141592653589793
    radius      dq  4.0

section .text
global _start
_start:
    movsd   xmm0, qword [radius]
    mulsd   xmm0, qword [radius]       ; r^2 = 16.0
    mulsd   xmm0, qword [pi]           ; pi * r^2 = 50.265...
    cvttsd2si rax, xmm0                ; 50

last:
    mov     rdi, rax                    ; exit status = 50
    mov     rax, SYS_exit
    syscall
