; -----------------------------------------------------------------------------
; Local array allocated on the stack
;
; Demonstrates: carving a byte array out of the stack frame with sub rsp,
;               filling it with mov byte [rbp - N], summing it with movzx
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 12.11 (Stack-Based Local Variables),
;               12.3 (Stack Dynamic Local Variables)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_11_local_array.lst ch12_11_local_array.asm && ld -g -o ch12_11_local_array ch12_11_local_array.o
; Run:    ./ch12_11_local_array ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
LEN              equ 5                   ; number of elements in the array

section .text
global _start

; -----------------------------------------------------------------------------
; localArraySum -- returns the sum of a 5-byte local array in rax.
;
; The array lives entirely inside this frame, growing downward from rbp:
;       [rbp - 1] .. [rbp - 5] = elements 1 .. 5
; Eight bytes are reserved (not five) to keep rsp 16-byte aligned.
localArraySum:
    push    rbp                         ; prologue
    mov     rbp, rsp
    sub     rsp, 8                      ; 5 bytes of array + alignment pad

    mov     byte [rbp - 1], 1           ; arr[0] = 1
    mov     byte [rbp - 2], 2           ; arr[1] = 2
    mov     byte [rbp - 3], 3           ; arr[2] = 3
    mov     byte [rbp - 4], 4           ; arr[3] = 4
    mov     byte [rbp - 5], 5           ; arr[4] = 5

    xor     rax, rax                    ; rax = running sum = 0
    lea     rsi, [rbp - LEN]            ; rsi = &arr[0] (lowest address)
    mov     rcx, LEN                    ; rcx = element count
.sumLoop:
    test    rcx, rcx                    ; any elements left?
    jz      .done
    movzx   edx, byte [rsi]             ; load one byte, zero-extended
    add     rax, rdx                    ; sum += element
    inc     rsi                         ; next byte
    dec     rcx
    jmp     .sumLoop
.done:
    mov     rsp, rbp                    ; epilogue: release the array
    pop     rbp
    ret

_start:
    call    localArraySum               ; rax = 1+2+3+4+5 = 15

last:
    mov     rdi, rax                    ; exit status = computed result (15)
    mov     rax, SYS_exit               ; call code for exit
    syscall
