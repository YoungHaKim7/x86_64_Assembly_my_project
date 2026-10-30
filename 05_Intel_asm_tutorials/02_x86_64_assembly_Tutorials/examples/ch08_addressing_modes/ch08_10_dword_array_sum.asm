; -----------------------------------------------------------------------------
; dword list summation: the book's List Summation example (sum = 150)
;
; Demonstrates: scaled-index loop summing a dword list, loop instruction
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.3 (List Processing, List Summation)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_10_dword_array_sum.lst ch08_10_dword_array_sum.asm && ld -g -o ch08_10_dword_array_sum ch08_10_dword_array_sum.o
; Run:    ./ch08_10_dword_array_sum ; echo $?        -> exit code: 150
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd 10, 20, 30, 40, 50      ; dword list to sum
    LEN         equ 5                      ; number of elements

section .text
global _start
_start:

; List Summation: sum every dword of the list.  The index register r12 is
; scaled by 4 (sizeof dword), the sum accumulates in eax.
; 10 + 20 + 30 + 40 + 50 = 150
    mov     eax, 0                         ; sum = 0
    mov     r12, 0                         ; i = 0
    mov     rcx, LEN                       ; rcx = element count (for loop)

sumLoop:
    add     eax, dword [dArr + r12*4]      ; sum += dArr[i]
    inc     r12                            ; i++
    loop    sumLoop                        ; dec rcx; repeat while rcx > 0

    mov     edi, eax                       ; exit code = 150

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
