; -----------------------------------------------------------------------------
; reverse an array with the stack: push {1,2,3,4,5}, pop into bss array
;
; Demonstrates: the stack as a reversing buffer for a whole list
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.2 (Stack Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_10_reverse_array.lst ch09_10_reverse_array.asm && ld -g -o ch09_10_reverse_array ch09_10_reverse_array.o
; Run:    ./ch09_10_reverse_array ; echo $?        -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 1, 2, 3, 4, 5           ; source list
    LEN         equ 5                      ; number of elements

section .bss
    qDst        resq LEN                   ; destination (reversed) list

section .text
global _start
_start:

; Phase 1 -- push every element in order; the last element ends on top.
    mov     r12, 0                         ; i = 0
    mov     rcx, LEN                       ; rcx = element count (for loop)
pushLoop:
    push    qword [qArr + r12*8]           ; push qArr[i]
    inc     r12                            ; i++
    loop    pushLoop                       ; dec rcx; repeat while rcx > 0

; Phase 2 -- pops deliver the elements back-to-front: qDst = {5,4,3,2,1}
    mov     r12, 0                         ; i = 0
    mov     rcx, LEN                       ; rcx = element count (for loop)
popLoop:
    pop     rax                            ; rax = next reversed element
    mov     qword [qDst + r12*8], rax      ; qDst[i] = rax
    inc     r12                            ; i++
    loop    popLoop                        ; dec rcx; repeat while rcx > 0

    mov     rdi, qword [qDst]              ; exit code = qDst[0] = 5

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
