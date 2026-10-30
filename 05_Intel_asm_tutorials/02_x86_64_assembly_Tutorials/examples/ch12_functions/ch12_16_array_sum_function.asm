; -----------------------------------------------------------------------------
; Array sum function (array address and length as arguments)
;
; Demonstrates: passing an array as (address, length) in rdi/rsi, walking
;               it with qword [rdi] and pointer bumping
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.9 (Example, Statistical
;               Function 1 (leaf))
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_16_array_sum_function.lst ch12_16_array_sum_function.asm && ld -g -o ch12_16_array_sum_function ch12_16_array_sum_function.o
; Run:    ./ch12_16_array_sum_function ; echo $?        -> exit code: 100
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qArr        dq 10, 20, 30, 40       ; test array
    qLen        dq 4                    ; element count

section .text
global _start

; -----------------------------------------------------------------------------
; arraySum -- rdi = array address, rsi = length; returns the sum in rax.
arraySum:
    push    rbx                         ; rbx (loop counter) is callee-saved
    mov     rbx, rsi                    ; rbx = number of elements
    xor     rax, rax                    ; rax = running sum = 0
.sumLoop:
    test    rbx, rbx                    ; any elements left?
    jz      .done
    add     rax, qword [rdi]            ; sum += *ptr
    add     rdi, 8                      ; advance to the next quadword
    dec     rbx
    jmp     .sumLoop
.done:
    pop     rbx
    ret

_start:
    mov     rdi, qArr                   ; argument 1: array address
    mov     rsi, qword [qLen]           ; argument 2: element count
    call    arraySum                    ; rax = 10+20+30+40 = 100

last:
    mov     rdi, rax                    ; exit status = computed result (100)
    mov     rax, SYS_exit               ; call code for exit
    syscall
