; -----------------------------------------------------------------------------
; Bubble sort function (ascending, in place)
;
; Demonstrates: nested-loop sorting with swapped element pairs, array
;               (address, length) arguments, callee-saved working registers
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.9 (Example, Statistical
;               Function 1 (leaf))
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_26_bubble_sort_function.lst ch12_26_bubble_sort_function.asm && ld -g -o ch12_26_bubble_sort_function ch12_26_bubble_sort_function.o
; Run:    ./ch12_26_bubble_sort_function ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qArr        dq 5, 1, 4, 2, 8        ; becomes 1, 2, 4, 5, 8
    qLen        dq 5

section .text
global _start

; -----------------------------------------------------------------------------
; bubbleSort -- rdi = array address, rsi = length; sorts the quadwords in
;               ascending order, in place. Returns nothing in rax.
;
; Outer pass shrinks the unsorted region; the inner pass bubbles the
; largest remaining element to the right by swapping out-of-order pairs.
; Working set: r12 = array base, r13 = last index of the unsorted region,
; rbx = inner index (all callee-saved, pushed and popped here).
bubbleSort:
    push    rbx
    push    r12
    push    r13
    mov     r12, rdi                    ; r12 = array base
    mov     r13, rsi
    dec     r13                         ; r13 = last index to compare to
.outer:
    test    r13, r13                    ; nothing left to compare?
    jz      .done
    xor     rbx, rbx                    ; rbx = i = 0
.inner:
    mov     rax, qword [r12 + rbx*8]    ; arr[i]
    mov     rdx, qword [r12 + rbx*8 + 8]; arr[i+1]
    cmp     rax, rdx                    ; pair already in order?
    jle     .noSwap
    mov     qword [r12 + rbx*8], rdx    ; swap the pair
    mov     qword [r12 + rbx*8 + 8], rax
.noSwap:
    inc     rbx
    cmp     rbx, r13                    ; end of this pass?
    jb      .inner
    dec     r13                         ; largest element settled; shrink
    jmp     .outer
.done:
    pop     r13
    pop     r12
    pop     rbx
    ret

_start:
    mov     rdi, qArr                   ; argument 1: array address
    mov     rsi, qword [qLen]           ; argument 2: element count
    call    bubbleSort                  ; qArr = {1, 2, 4, 5, 8}

    mov     rax, qword [qArr]           ; first element = 1

last:
    mov     rdi, rax                    ; exit status = 1
    mov     rax, SYS_exit               ; call code for exit
    syscall
