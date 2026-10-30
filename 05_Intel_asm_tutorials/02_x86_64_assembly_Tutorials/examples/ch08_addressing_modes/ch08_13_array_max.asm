; -----------------------------------------------------------------------------
; list maximum: max of {12,45,7,88,23} = 88 via compare-and-replace loop
;
; Demonstrates: finding a list maximum with cmp/jle and scaled indexing
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.3 (List Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_13_array_max.lst ch08_13_array_max.asm && ld -g -o ch08_13_array_max ch08_13_array_max.o
; Run:    ./ch08_13_array_max ; echo $?        -> exit code: 88
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd 12, 45, 7, 88, 23       ; dword list to scan
    LEN         equ 5                      ; number of elements

section .text
global _start
_start:

; Seed the maximum with element 0, then compare every remaining element:
; a bigger value replaces the running maximum, smaller ones are skipped.
    mov     eax, dword [dArr]              ; max = dArr[0] = 12
    mov     r12, 1                         ; i = 1 (element 0 already used)
    mov     rcx, LEN-1                     ; LEN-1 elements left to test

maxLoop:
    cmp     dword [dArr + r12*4], eax      ; compare dArr[i] with max
    jle     nextElem                       ; dArr[i] <= max -> keep old max
    mov     eax, dword [dArr + r12*4]      ; new maximum found
nextElem:
    inc     r12                            ; i++
    loop    maxLoop                        ; dec rcx; repeat while rcx > 0

    mov     edi, eax                       ; exit code = 88

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
