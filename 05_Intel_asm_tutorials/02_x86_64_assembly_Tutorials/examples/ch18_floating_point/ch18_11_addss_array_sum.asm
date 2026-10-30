; -----------------------------------------------------------------------------
; Summing a float array with addss
;
; Demonstrates: array traversal in xmm registers
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_11.lst ch18_11_addss_array_sum.asm && ld -g -o ch18_11_addss_array_sum ch18_11_addss_array_sum.o
; Run:    ./ch18_11_addss_array_sum ; echo $?        -> exit code: 11
;
; {1.5, 2.5, 3.0, 4.0} sums to 11.0 exactly (no rounding error).
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltArr      dd  1.5, 2.5, 3.0, 4.0
    arrLen      equ ($-fltArr)/4

section .text
global _start
_start:
    xorps   xmm0, xmm0                 ; running sum = 0.0f
    mov     rsi, fltArr
    mov     rcx, arrLen

.sumLoop:
    test    rcx, rcx
    jz      .done
    addss   xmm0, dword [rsi]          ; sum += element
    add     rsi, 4
    dec     rcx
    jmp     .sumLoop
.done:
    cvttss2si rax, xmm0                ; 11

last:
    mov     rdi, rax                    ; exit status = 11
    mov     rax, SYS_exit
    syscall
