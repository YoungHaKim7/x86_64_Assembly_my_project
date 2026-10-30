; -----------------------------------------------------------------------------
; Project 01 -- sum and average split across three source files
;
; Demonstrates: global/extern linkage; main.asm drives, sum.asm computes,
;               io.asm prints (book ch 14.1 - 14.2)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 14.2 (Example, Sum and Average)
;
; Build:  bash build.sh
; Run:    ./proj_01_sum_average
;         -> sum=100
;            avg=25
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

extern arraySum                  ; from sum.asm
extern printInt                  ; from io.asm
extern printString               ; from io.asm

section .data
    qArray      dq  10, 20, 30, 40
    qLen        equ ($-qArray)/8
    sumLabel    db  "sum="
    sumLabLen   equ $-sumLabel
    avgLabel    db  "avg="
    avgLabLen   equ $-avgLabel

section .text
global _start
_start:
    mov     rdi, sumLabel              ; print "sum="
    mov     rsi, sumLabLen
    call    printString

    mov     rdi, qArray                ; rdi = array address
    mov     rsi, qLen                  ; rsi = element count
    call    arraySum                   ; rax = 100
    mov     r12, rax                   ; keep the sum (printInt clobbers rcx)

    mov     rdi, r12
    call    printInt                   ; "100\n"

    mov     rdi, avgLabel
    mov     rsi, avgLabLen
    call    printString

    mov     rax, r12
    xor     rdx, rdx
    mov     rbx, qLen
    div     rbx                        ; avg = 100/4
    mov     rdi, rax
    call    printInt                   ; "25\n"

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
