; -----------------------------------------------------------------------------
; Counting evens -- test/jz over an array
;
; Demonstrates: parity test via and #1 + jz, array traversal loop
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_152.lst ch07_152_count_even.asm && ld -g -o ch07_152_count_even ch07_152_count_even.o
; Run:    ./ch07_152_count_even ; echo $?        -> exit code: 2
;
; {1,4,6,7,9} -> evens are 4 and 6 -> count 2.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq  1, 4, 6, 7, 9
    qLen        equ ($-qArr)/8

section .text
global _start
_start:
    mov     rsi, qArr                  ; element pointer
    mov     rcx, qLen                  ; elements remaining
    xor     rax, rax                   ; even count = 0

.countLoop:
    test    rcx, rcx
    jz      last                       ; done
    mov     rbx, qword [rsi]
    test    bl, 1                      ; low bit set?
    jnz     .odd
    inc     rax                        ; even
.odd:
    add     rsi, 8
    dec     rcx
    jmp     .countLoop

last:
    mov     rdi, rax                   ; exit status = 2
    mov     rax, SYS_exit
    syscall
