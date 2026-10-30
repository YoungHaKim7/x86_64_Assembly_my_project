; -----------------------------------------------------------------------------
; list average: (10+20+30+40+50)/5 = 30 via summation then unsigned divide
;
; Demonstrates: list summation followed by div to average a dword list
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.3 (List Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_12_array_average.lst ch08_12_array_average.asm && ld -g -o ch08_12_array_average ch08_12_array_average.o
; Run:    ./ch08_12_array_average ; echo $?        -> exit code: 30
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd 10, 20, 30, 40, 50      ; dword list to average
    LEN         equ 5                      ; number of elements

section .text
global _start
_start:

; Pass 1 -- sum the list (see ch08_10): 10+20+30+40+50 = 150
    mov     eax, 0                         ; sum = 0
    mov     r12, 0                         ; i = 0
    mov     rcx, LEN                       ; rcx = element count (for loop)

sumLoop:
    add     eax, dword [dArr + r12*4]      ; sum += dArr[i]
    inc     r12                            ; i++
    loop    sumLoop                        ; dec rcx; repeat while rcx > 0

; Pass 2 -- average = sum / count.  div uses the edx:eax pair, so edx MUST
; be cleared first or stale bits would quadruple the dividend.
    xor     edx, edx                       ; edx = 0 (high dword of dividend)
    mov     ecx, LEN                       ; ecx = divisor (5)
    div     ecx                            ; eax = 150 / 5 = 30, edx = rem 0

    mov     edi, eax                       ; exit code = 30

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
