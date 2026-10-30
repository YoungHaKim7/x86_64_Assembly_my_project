; -----------------------------------------------------------------------------
; Floating-point average -- divide once at the end
;
; Demonstrates: sum-then-divide with exact integer results
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_13.lst ch18_13_float_average.asm && ld -g -o ch18_13_float_average ch18_13_float_average.o
; Run:    ./ch18_13_float_average ; echo $?        -> exit code: 5
;
; The book's statistics data {2,4,4,4,5,5,7,9}: sum 40, count 8, mean 5.0.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltArr      dd  2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0
    arrLen      equ ($-fltArr)/4
    fltCnt      dd  8.0                 ; element count as a FLOAT literal --
                                        ; dd 8 would store integer bits!

section .text
global _start
_start:
    xorps   xmm0, xmm0
    mov     rsi, fltArr
    mov     rcx, arrLen

.sumLoop:
    test    rcx, rcx
    jz      .avg
    addss   xmm0, dword [rsi]
    add     rsi, 4
    dec     rcx
    jmp     .sumLoop

.avg:
    movss   xmm1, dword [fltCnt]
    divss   xmm0, xmm1                 ; mean = 40/8 = 5.0f
    cvttss2si rax, xmm0                ; 5

last:
    mov     rdi, rax                    ; exit status = 5
    mov     rax, SYS_exit
    syscall
