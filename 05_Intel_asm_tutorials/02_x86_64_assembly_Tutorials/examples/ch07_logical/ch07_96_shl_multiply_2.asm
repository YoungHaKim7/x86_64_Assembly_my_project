; -----------------------------------------------------------------------------
; SHL as multiply-by-2: 21 shl 1 = 42 (double a value)
;
; Demonstrates: shl instruction as a fast multiply by a power of two
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_96.lst ch07_96_shl_multiply_2.asm && ld -g -o ch07_96 ch07_96_shl_multiply_2.o
; Run:    ./ch07_96 ; echo $?        -> exit code: 42
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Shifting left one position appends a 0 in bit 0, which doubles the value:
; 21 = 0001 0101 -> 0010 1010 = 42.
    mov     al, 21                      ; al = 21
    shl     al, 1                       ; al = 42 (21 * 2^1)

; Cross-check with a real doubling addition: 21 + 21 must also be 42.
    mov     bl, 21
    add     bl, bl                      ; bl = 42
    mov     edi, EXIT_SUCCESS           ; status 0 if the results differ
    cmp     al, bl                      ; shl result vs add result
    jne     last                        ; mismatch (never taken here)
    movzx   edi, al                     ; agree: exit with 42

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (42)
