; -----------------------------------------------------------------------------
; A labeled loop made for breakpoint inspection (sum of 1..5)
;
; Demonstrates: debugger-friendly structure: labels (sumLoop, last), a counter
;               register (rbx) and an accumulator (r12) to watch in gdb
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 6.0 (DDD Debugger)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch06_01_debugger_demo.lst ch06_01_debugger_demo.asm && ld -g -o ch06_01 ch06_01_debugger_demo.o
; Debug:  gdb -x ch06_01.gdb ./ch06_01     (run from this directory)
; Run:    ./ch06_01 ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

    mov     rbx, 1                          ; rbx = current term i, starts at 1
    xor     r12, r12                        ; r12 = running sum, starts at 0

sumLoop:
    add     r12, rbx                        ; sum += i   (watch r12 here)
    inc     rbx                             ; i++
    cmp     rbx, 5                          ; while i <= 5
    jbe     sumLoop                         ; loop body ends, i goes 1..5

; r12 = 1 + 2 + 3 + 4 + 5 = 15
last:
    mov     rax, SYS_exit                   ; call code for exit
    mov     rdi, r12                        ; exit code 15
    syscall
