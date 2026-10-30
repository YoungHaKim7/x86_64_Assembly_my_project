; -----------------------------------------------------------------------------
; Maximum of a float array -- comiss in a loop
;
; Demonstrates: comiss driving ja/jb decisions per element
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 18.5 - 18.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_14.lst ch18_14_array_max_ss.asm && ld -g -o ch18_14_array_max_ss ch18_14_array_max_ss.o
; Run:    ./ch18_14_array_max_ss ; echo $?        -> exit code: 9
;
; max{1.5, 9.5, 3.0} = 9.5; truncation reports 9.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltArr      dd  1.5, 9.5, 3.0
    arrLen      equ ($-fltArr)/4

section .text
global _start
_start:
    movss   xmm0, dword [fltArr]       ; candidate = first element
    mov     rsi, fltArr + 4             ; start from the second element
    mov     rcx, arrLen - 1

.maxLoop:
    test    rcx, rcx
    jz      .done
    movss   xmm1, dword [rsi]
    comiss  xmm1, xmm0                 ; element above candidate?
    ja      .newMax                    ; unsigned-style jumps work for
    jmp     .next                       ; ordered float compares
.newMax:
    movss   xmm0, xmm1
.next:
    add     rsi, 4
    dec     rcx
    jmp     .maxLoop
.done:
    cvttss2si rax, xmm0                ; 9

last:
    mov     rdi, rax                    ; exit status = 9
    mov     rax, SYS_exit
    syscall
