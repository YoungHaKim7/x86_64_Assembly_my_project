; -----------------------------------------------------------------------------
; byte array summation: sum of {1,2,3,4,5} using base+index addressing
;
; Demonstrates: looping over a byte array with [bArr + r12], accumulate
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.3 (List Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_08_byte_array_sum.lst ch08_08_byte_array_sum.asm && ld -g -o ch08_08_byte_array_sum ch08_08_byte_array_sum.o
; Run:    ./ch08_08_byte_array_sum ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bArr        db 1, 2, 3, 4, 5           ; byte list to sum
    LEN         equ 5                      ; number of elements

section .text
global _start
_start:

; Walk the list: index i in r12, running sum in bl (bytes need no scale).
; 1 + 2 + 3 + 4 + 5 = 15
    mov     rbx, 0                         ; sum = 0 (kept in bl)
    mov     r12, 0                         ; i = 0
    mov     rcx, LEN                       ; rcx = element count (for loop)

sumLoop:
    mov     al, byte [bArr + r12]          ; al = bArr[i]
    add     bl, al                         ; sum += bArr[i]
    inc     r12                            ; i++
    loop    sumLoop                        ; dec rcx; repeat while rcx > 0

    movzx   edi, bl                        ; exit code = 15 (zero-extended)

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
