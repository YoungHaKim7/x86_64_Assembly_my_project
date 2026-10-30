; -----------------------------------------------------------------------------
; word array summation: sum of {90,95,70} using scaled index addressing
;
; Demonstrates: looping over a word array with [wArr + r12*2], movzx word
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.3 (List Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_09_word_array_sum.lst ch08_09_word_array_sum.asm && ld -g -o ch08_09_word_array_sum ch08_09_word_array_sum.o
; Run:    ./ch08_09_word_array_sum ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    wArr        dw 90, 95, 70              ; word list to sum
    LEN         equ 3                      ; number of elements

section .text
global _start
_start:

; Word elements are 2 bytes, so the index is scaled by 2.  Each element is
; zero-extended into a full quadword before being added to the 64-bit sum.
; 90 + 95 + 70 = 255
    mov     rbx, 0                         ; sum = 0
    mov     r12, 0                         ; i = 0
    mov     rcx, LEN                       ; rcx = element count (for loop)

sumLoop:
    movzx   rax, word [wArr + r12*2]       ; rax = wArr[i] (zero-extended)
    add     rbx, rax                       ; sum += wArr[i]
    inc     r12                            ; i++
    loop    sumLoop                        ; dec rcx; repeat while rcx > 0

    mov     rdi, rbx                       ; exit code = 255

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
