; -----------------------------------------------------------------------------
; list minimum: min of {12,45,7,88,23} = 7 via compare-and-replace loop
;
; Demonstrates: finding a list minimum with cmp/jge and scaled indexing
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.3 (List Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_14_array_min.lst ch08_14_array_min.asm && ld -g -o ch08_14_array_min ch08_14_array_min.o
; Run:    ./ch08_14_array_min ; echo $?        -> exit code: 7
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd 12, 45, 7, 88, 23       ; dword list to scan
    LEN         equ 5                      ; number of elements

section .text
global _start
_start:

; Mirror image of the maximum search: seed with element 0, replace whenever
; a SMALLER element is seen (jge skips everything not below the minimum).
    mov     eax, dword [dArr]              ; min = dArr[0] = 12
    mov     r12, 1                         ; i = 1 (element 0 already used)
    mov     rcx, LEN-1                     ; LEN-1 elements left to test

minLoop:
    cmp     dword [dArr + r12*4], eax      ; compare dArr[i] with min
    jge     nextElem                       ; dArr[i] >= min -> keep old min
    mov     eax, dword [dArr + r12*4]      ; new minimum found
nextElem:
    inc     r12                            ; i++
    loop    minLoop                        ; dec rcx; repeat while rcx > 0

    mov     edi, eax                       ; exit code = 7

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
