; -----------------------------------------------------------------------------
; Integer variance function (two-pass algorithm)
;
; Demonstrates: a two-pass statistical function in the book's style: pass 1
;               computes the mean, pass 2 accumulates squared deviations,
;               finishing with the population variance
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.9 - 12.10 (statistical examples)
;
; Data: {2,4,4,4,5,5,7,9} -> mean 5, squared deviations 9+1+1+1+0+0+4+16=32,
;       variance 32/8 = 4.
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_19_variance_function.lst ch12_19_variance_function.asm && ld -g -o ch12_19_variance_function ch12_19_variance_function.o
; Run:    ./ch12_19_variance_function ; echo $?        -> exit code: 4
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qArr        dq 2, 4, 4, 4, 5, 5, 7, 9
    qLen        dq 8

section .text
global _start

; -----------------------------------------------------------------------------
; variance -- rdi = array address, rsi = length (>= 1); returns the integer
;             population variance in rax.
;
; Working values parked in callee-saved registers (all pushed/popped):
;   r12 = array address, r13 = length, r14 = mean, rbx = index.
variance:
    push    rbx
    push    r12
    push    r13
    push    r14
    mov     r12, rdi                    ; array address
    mov     r13, rsi                    ; length

    ; ---- pass 1: mean = sum / length --------------------------------------
    xor     rax, rax                    ; rax = running sum = 0
    xor     rbx, rbx                    ; rbx = index = 0
.sumLoop:
    cmp     rbx, r13                    ; index < length?
    jae     .meanDone
    add     rax, qword [r12 + rbx*8]    ; sum += arr[i]
    inc     rbx
    jmp     .sumLoop
.meanDone:
    xor     rdx, rdx
    div     r13                         ; rax = mean (integer)
    mov     r14, rax                    ; r14 = mean

    ; ---- pass 2: sum of squared deviations --------------------------------
    xor     rax, rax                    ; rax = deviation accumulator = 0
    xor     rbx, rbx                    ; index = 0 again
.devLoop:
    cmp     rbx, r13
    jae     .final
    mov     rcx, qword [r12 + rbx*8]    ; rcx = arr[i]
    sub     rcx, r14                    ; rcx = arr[i] - mean (may be < 0)
    imul    rcx, rcx                    ; rcx = (arr[i] - mean)^2, always >= 0
    add     rax, rcx                    ; accumulate
    inc     rbx
    jmp     .devLoop
.final:
    xor     rdx, rdx
    div     r13                         ; rax = variance = devs / length

    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret

_start:
    mov     rdi, qArr                   ; argument 1: array address
    mov     rsi, qword [qLen]           ; argument 2: element count
    call    variance                    ; rax = 4

last:
    mov     rdi, rax                    ; exit status = computed result (4)
    mov     rax, SYS_exit               ; call code for exit
    syscall
