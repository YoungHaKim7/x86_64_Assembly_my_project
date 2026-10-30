; -----------------------------------------------------------------------------
; Selection sort function (ascending, in place)
;
; Demonstrates: min-index search and single swap per pass, indexed
;               addressing with scale, callee-saved working registers
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.9 (Example, Statistical
;               Function 1 (leaf))
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_27_selection_sort_function.lst ch12_27_selection_sort_function.asm && ld -g -o ch12_27_selection_sort_function ch12_27_selection_sort_function.o
; Run:    ./ch12_27_selection_sort_function ; echo $?        -> exit code: 3
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qArr        dq 9, 3, 7              ; becomes 3, 7, 9
    qLen        dq 3

section .text
global _start

; -----------------------------------------------------------------------------
; selectionSort -- rdi = array address, rsi = length; sorts ascending,
;                  in place. Returns nothing in rax.
;
; For each position i, find the smallest element in arr[i..n-1] and swap it
; into arr[i]. Working set: r12 = base, r13 = n, rbx = i, r14 = min index
; (all callee-saved, pushed and popped here).
selectionSort:
    push    rbx
    push    r12
    push    r13
    push    r14
    mov     r12, rdi                    ; r12 = array base
    mov     r13, rsi                    ; r13 = element count
    xor     rbx, rbx                    ; rbx = i = 0
.outer:
    lea     rax, [r13 - 1]              ; last position that needs filling
    cmp     rbx, rax
    jae     .done                       ; i >= n-1 -> sorted
    mov     r14, rbx                    ; r14 = minIdx = i
    lea     rcx, [rbx + 1]              ; rcx = j = i+1
.inner:
    cmp     rcx, r13                    ; j < n?
    jae     .swap
    mov     rax, qword [r12 + rcx*8]    ; arr[j]
    mov     rdx, qword [r12 + r14*8]    ; arr[minIdx]
    cmp     rax, rdx
    jge     .nextJ                      ; not smaller -> keep minIdx
    mov     r14, rcx                    ; new minimum found
.nextJ:
    inc     rcx
    jmp     .inner
.swap:
    cmp     r14, rbx                    ; minimum already in place?
    je      .nextI
    mov     rax, qword [r12 + rbx*8]    ; swap arr[i] <-> arr[minIdx]
    mov     rdx, qword [r12 + r14*8]
    mov     qword [r12 + rbx*8], rdx
    mov     qword [r12 + r14*8], rax
.nextI:
    inc     rbx
    jmp     .outer
.done:
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret

_start:
    mov     rdi, qArr                   ; argument 1: array address
    mov     rsi, qword [qLen]           ; argument 2: element count
    call    selectionSort               ; qArr = {3, 7, 9}

    mov     rax, qword [qArr]           ; first element = 3

last:
    mov     rdi, rax                    ; exit status = 3
    mov     rax, SYS_exit               ; call code for exit
    syscall
