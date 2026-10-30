; -----------------------------------------------------------------------------
; Array integer-average function
;
; Demonstrates: accumulate then divide inside one function; the element
;               count must be preserved across the summation loop in
;               callee-saved rbx
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.9 (Example, Statistical
;               Function 1 (leaf))
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_18_array_average_function.lst ch12_18_array_average_function.asm && ld -g -o ch12_18_array_average_function ch12_18_array_average_function.o
; Run:    ./ch12_18_array_average_function ; echo $?        -> exit code: 8
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qArr        dq 8, 9, 7, 10, 6       ; sum = 40, len = 5, average = 8
    qLen        dq 5

section .text
global _start

; -----------------------------------------------------------------------------
; arrayAverage -- rdi = array address, rsi = length (>= 1); returns the
;                 integer average (truncated toward zero) in rax.
arrayAverage:
    push    rbx                         ; preserve rbx for our caller
    mov     rbx, rsi                    ; rbx = count, needed AFTER the loop
    xor     rax, rax                    ; rax = running sum = 0
.sumLoop:
    test    rsi, rsi                    ; any elements left?
    jz      .divide
    add     rax, qword [rdi]            ; sum += *ptr
    add     rdi, 8                      ; next quadword
    dec     rsi
    jmp     .sumLoop
.divide:
    xor     rdx, rdx                    ; rdx = 0 before unsigned division
    div     rbx                         ; rax = sum / count
    pop     rbx
    ret

_start:
    mov     rdi, qArr                   ; argument 1: array address
    mov     rsi, qword [qLen]           ; argument 2: element count
    call    arrayAverage                ; rax = 40 / 5 = 8

last:
    mov     rdi, rax                    ; exit status = computed result (8)
    mov     rax, SYS_exit               ; call code for exit
    syscall
