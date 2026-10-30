; -----------------------------------------------------------------------------
; cmov chain -- median of three values, fully branchless
;
; Demonstrates: composing several cmovcc instructions into one selection
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_136.lst ch07_136_cmov_median.asm && ld -g -o ch07_136_cmov_median ch07_136_cmov_median.o
; Run:    ./ch07_136_cmov_median ; echo $?        -> exit code: 5
;
; Formula: median(a,b,c) = max( min(a,b), min( max(a,b), c ) )
; with (5,9,2): min=5, max=9, min(9,2)=2, max(5,2)=5.
; Each min/max is one cmp + one cmov -- three values, four cmovs total.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     r8, 5                      ; a
    mov     r9, 9                      ; b
    mov     r10, 2                     ; c

    mov     rax, r8                    ; rax = candidate for min(a,b)
    cmp     r9, rax
    cmovl   rax, r9                    ; rax = min(a,b) = 5

    mov     rdx, r8                    ; rdx = candidate for max(a,b)
    cmp     r9, rdx
    cmovg   rdx, r9                    ; rdx = max(a,b) = 9

    cmp     r10, rdx
    cmovl   rdx, r10                   ; rdx = min(max(a,b), c) = 2

    cmp     rdx, rax
    cmovg   rax, rdx                   ; rax = max(5, 2) = 5 = median

last:
    mov     rdi, rax                   ; exit status = 5
    mov     rax, SYS_exit
    syscall
