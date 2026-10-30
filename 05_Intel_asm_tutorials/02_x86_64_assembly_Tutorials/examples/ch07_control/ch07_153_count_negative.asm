; -----------------------------------------------------------------------------
; Counting negatives -- signed test over an array
;
; Demonstrates: js (sign flag) loop over quadword array
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_153.lst ch07_153_count_negative.asm && ld -g -o ch07_153_count_negative ch07_153_count_negative.o
; Run:    ./ch07_153_count_negative ; echo $?        -> exit code: 3
;
; {5,-3,8,-9,-1} -> three negative values.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq  5, -3, 8, -9, -1
    qLen        equ ($-qArr)/8

section .text
global _start
_start:
    mov     rsi, qArr
    mov     rcx, qLen
    xor     rax, rax                   ; negative count

.countLoop:
    test    rcx, rcx
    jz      last
    mov     rbx, qword [rsi]
    test    rbx, rbx                   ; load SF
    jns     .notNeg
    inc     rax
.notNeg:
    add     rsi, 8
    dec     rcx
    jmp     .countLoop

last:
    mov     rdi, rax                   ; exit status = 3
    mov     rax, SYS_exit
    syscall
