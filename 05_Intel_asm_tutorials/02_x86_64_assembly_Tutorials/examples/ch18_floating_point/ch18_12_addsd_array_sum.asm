; -----------------------------------------------------------------------------
; Summing a double array with addsd
;
; Demonstrates: 64-bit element stride with movsd/addsd
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.5 (Floating-Point Arithmetic)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_12.lst ch18_12_addsd_array_sum.asm && ld -g -o ch18_12_addsd_array_sum ch18_12_addsd_array_sum.o
; Run:    ./ch18_12_addsd_array_sum ; echo $?        -> exit code: 7
;
; {1.25, 2.5, 3.25} sums to 7.0 exactly.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dblArr      dq  1.25, 2.5, 3.25
    arrLen      equ ($-dblArr)/8

section .text
global _start
_start:
    xorps   xmm0, xmm0                 ; zero the whole register first
    mov     rsi, dblArr
    mov     rcx, arrLen

.sumLoop:
    test    rcx, rcx
    jz      .done
    addsd   xmm0, qword [rsi]
    add     rsi, 8
    dec     rcx
    jmp     .sumLoop
.done:
    cvttsd2si rax, xmm0                ; 7

last:
    mov     rdi, rax                    ; exit status = 7
    mov     rax, SYS_exit
    syscall
