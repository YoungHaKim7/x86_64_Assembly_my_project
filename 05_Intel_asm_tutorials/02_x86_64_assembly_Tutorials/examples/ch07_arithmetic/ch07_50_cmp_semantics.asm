; -----------------------------------------------------------------------------
; cmp: compare sets flags without changing either operand
;
; Demonstrates: cmp computes dest - src for flags only; operands survive
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_50.lst ch07_50_cmp_semantics.asm && ld -g -o ch07_50 ch07_50_cmp_semantics.o
; Run:    ./ch07_50 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; cmp performs the subtraction 10 - 10 = 0 purely to set flags:
; ZF = 1 (equal), then discards the difference -- rax and rbx keep 10
    mov     rax, 10                       ; rax = 10
    mov     rbx, 10                       ; rbx = 10
    cmp     rax, rbx                      ; sets ZF = 1, changes no registers
    jne     notEqual                      ; ZF clear -> operands differ

; equal: prove cmp really preserved its operands (rax must still be 10;
; if cmp had stored its result, rax would read 0 and this check would fail)
    cmp     rax, 10                       ; rax still 10?
    jne     notEqual                      ; operands clobbered -> bail out

    mov     rdi, 1                        ; exit 1: je taken AND rax intact
    jmp     last

notEqual:
    mov     rdi, EXIT_SUCCESS             ; exit 0: unexpected outcome

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
