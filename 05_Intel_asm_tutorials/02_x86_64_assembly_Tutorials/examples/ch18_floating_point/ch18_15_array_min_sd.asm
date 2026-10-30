; -----------------------------------------------------------------------------
; Minimum of a double array -- comisd in a loop
;
; Demonstrates: comisd with jb selection
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 18.5 - 18.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_15.lst ch18_15_array_min_sd.asm && ld -g -o ch18_15_array_min_sd ch18_15_array_min_sd.o
; Run:    ./ch18_15_array_min_sd ; echo $?        -> exit code: 1
;
; min{2.5, 1.25, 7.0} = 1.25; truncation reports 1.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dblArr      dq  2.5, 1.25, 7.0
    arrLen      equ ($-dblArr)/8

section .text
global _start
_start:
    movsd   xmm0, qword [dblArr]       ; candidate = first element
    mov     rsi, dblArr + 8
    mov     rcx, arrLen - 1

.minLoop:
    test    rcx, rcx
    jz      .done
    movsd   xmm1, qword [rsi]
    comisd  xmm1, xmm0                 ; element below candidate?
    jb      .newMin
    jmp     .next
.newMin:
    movsd   xmm0, xmm1
.next:
    add     rsi, 8
    dec     rcx
    jmp     .minLoop
.done:
    cvttsd2si rax, xmm0                ; 1

last:
    mov     rdi, rax                    ; exit status = 1
    mov     rax, SYS_exit
    syscall
