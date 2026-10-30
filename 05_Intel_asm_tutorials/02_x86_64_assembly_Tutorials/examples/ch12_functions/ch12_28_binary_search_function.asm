; -----------------------------------------------------------------------------
; Binary search function (sorted array)
;
; Demonstrates: divide-and-conquer search over (array, length, key), index
;               addressing [rdi + mid*8], returning -1 on a miss
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.5 (Standard Calling Convention),
;               12.9 (Example, Statistical Function 1 (leaf))
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_28_binary_search_function.lst ch12_28_binary_search_function.asm && ld -g -o ch12_28_binary_search_function ch12_28_binary_search_function.o
; Run:    ./ch12_28_binary_search_function ; echo $?        -> exit code: 4
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qArr        dq 2, 5, 8, 12, 16, 23, 38   ; sorted ascending
    qLen        dq 7

section .text
global _start

; -----------------------------------------------------------------------------
; bSearch -- rdi = sorted array address, rsi = length, rdx = key; returns
;            the index of key in rax, or -1 if key is absent.
;
; Classic low/high window: compare the middle element, then keep either the
; left or the right half. Working set: r12 = low, r13 = high, rbx = mid,
; r14 = arr[mid] (all callee-saved, pushed and popped here).
bSearch:
    push    rbx
    push    r12
    push    r13
    push    r14
    xor     r12, r12                    ; r12 = low = 0
    mov     r13, rsi
    dec     r13                         ; r13 = high = length - 1
.loop:
    cmp     r12, r13                    ; window empty -> not found
    jg      .notFound
    mov     rbx, r12
    add     rbx, r13
    shr     rbx, 1                      ; rbx = mid = (low + high) / 2
    mov     r14, qword [rdi + rbx*8]    ; r14 = arr[mid]
    cmp     r14, rdx
    je      .found                      ; arr[mid] == key
    jl      .right                      ; arr[mid] <  key -> go right
    lea     r13, [rbx - 1]              ; arr[mid] > key -> go left
    jmp     .loop
.right:
    lea     r12, [rbx + 1]              ; low = mid + 1
    jmp     .loop
.found:
    mov     rax, rbx                    ; rax = index of key
    jmp     .done
.notFound:
    mov     rax, -1                     ; conventional miss marker
.done:
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    ret

_start:
    mov     rdi, qArr                   ; argument 1: array address
    mov     rsi, qword [qLen]           ; argument 2: element count
    mov     rdx, 16                     ; argument 3: key to find
    call    bSearch                     ; rax = 4 (16 sits at index 4)

last:
    mov     rdi, rax                    ; exit status = 4
    mov     rax, SYS_exit               ; call code for exit
    syscall
