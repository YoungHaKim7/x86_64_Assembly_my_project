; -----------------------------------------------------------------------------
; Reference example: function / calling-convention style
;
; Demonstrates: leaf function, arguments in rdi/rsi/rdx, return in rax,
;               callee-saved register save/restore
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.5 - 12.8 (Standard Calling Convention)
;
; Build:  yasm -f elf64 -g dwarf2 -l chR_02.lst chR_02_function_style.asm && ld -g -o chR_02 chR_02_function_style.o
; Run:    ./chR_02 ; echo $?        -> exit code: 30
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArray      dq 5, 12, 3, 9, 1      ; test array, 5 elements
    qLen        dq 5

section .text
global _start

; -----------------------------------------------------------------------------
; sumThree -- leaf function: returns rdi + rsi + rdx in rax
sumThree:
    mov     rax, rdi                   ; start with first argument
    add     rax, rsi                   ; add second
    add     rax, rdx                   ; add third
    ret                                ; result in rax

; -----------------------------------------------------------------------------
; arraySum -- rdi = array address, rsi = length; returns sum in rax
; Uses callee-saved rbx (must be saved/restored per the convention).
arraySum:
    push    rbx                        ; save callee-saved register
    mov     rbx, rsi                   ; rbx = element count
    xor     rax, rax                   ; rax = running sum = 0
.sumLoop:
    test    rbx, rbx                   ; any elements left?
    jz      .done
    add     rax, qword [rdi]           ; add current element
    add     rdi, 8                     ; advance to next quadword
    dec     rbx
    jmp     .sumLoop
.done:
    pop     rbx                        ; restore callee-saved register
    ret

; -----------------------------------------------------------------------------
_start:
    mov     rdi, 10
    mov     rsi, 7
    mov     rdx, 13
    call    sumThree                   ; rax = 30

    push    rax                        ; keep first result across next call
    mov     rdi, qArray                ; arg 1: array address
    mov     rsi, qword [qLen]          ; arg 2: element count
    call    arraySum                   ; rax = 5+12+3+9+1 = 30
    pop     rcx                        ; rcx = 30 (first result)

    add     rax, rcx                   ; rax = 60 total (see comments)
    sub     rax, 30                    ; report the single-call result: 30

last:
    mov     rdi, rax                   ; exit status = computed result (30)
    mov     rax, SYS_exit              ; call code for exit
    syscall
