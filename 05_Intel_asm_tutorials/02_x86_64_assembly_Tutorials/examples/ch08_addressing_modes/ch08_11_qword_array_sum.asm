; -----------------------------------------------------------------------------
; qword array summation: sum of {5,10,15,20} with 64-bit scaled indexing
;
; Demonstrates: looping over a qword array with [qArr + r12*8], add r64
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.3 (List Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_11_qword_array_sum.lst ch08_11_qword_array_sum.asm && ld -g -o ch08_11_qword_array_sum ch08_11_qword_array_sum.o
; Run:    ./ch08_11_qword_array_sum ; echo $?        -> exit code: 50
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 5, 10, 15, 20           ; qword list to sum
    LEN         equ 4                      ; number of elements

section .text
global _start
_start:

; Qword elements are 8 bytes, so the scale is 8; the whole element fits in
; a single 64-bit register, so no movzx is needed.
; 5 + 10 + 15 + 20 = 50
    mov     rax, 0                         ; sum = 0
    mov     r12, 0                         ; i = 0
    mov     rcx, LEN                       ; rcx = element count (for loop)

sumLoop:
    add     rax, qword [qArr + r12*8]      ; sum += qArr[i]
    inc     r12                            ; i++
    loop    sumLoop                        ; dec rcx; repeat while rcx > 0

    mov     rdi, rax                       ; exit code = 50

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
