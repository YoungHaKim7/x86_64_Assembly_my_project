; -----------------------------------------------------------------------------
; reverse copy: copy {1,2,3,4,5} into a bss array in reverse order
;
; Demonstrates: writing through [dst + i] while reading [src + LEN-1-i]
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.3 (List Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_15_reverse_copy.lst ch08_15_reverse_copy.asm && ld -g -o ch08_15_reverse_copy ch08_15_reverse_copy.o
; Run:    ./ch08_15_reverse_copy ; echo $?        -> exit code: 5
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    srcArr      db 1, 2, 3, 4, 5           ; source byte list
    LEN         equ 5                      ; number of elements

section .bss
    dstArr      resb LEN                   ; destination (bss starts as 0)

section .text
global _start
_start:

; Element i of the destination receives element LEN-1-i of the source:
;   dstArr[0]=5  dstArr[1]=4  dstArr[2]=3  dstArr[3]=2  dstArr[4]=1
    mov     r12, 0                         ; i = destination index
    mov     rcx, LEN                       ; rcx = element count (for loop)

revLoop:
    mov     r13, LEN-1                     ; r13 = last source index
    sub     r13, r12                       ; r13 = LEN-1-i (source index)
    mov     al, byte [srcArr + r13]        ; al = srcArr[LEN-1-i]
    mov     byte [dstArr + r12], al        ; dstArr[i] = al
    inc     r12                            ; i++
    loop    revLoop                        ; dec rcx; repeat while rcx > 0

    movzx   edi, byte [dstArr]             ; exit code = dstArr[0] = 5

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
