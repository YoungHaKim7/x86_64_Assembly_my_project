; -----------------------------------------------------------------------------
; sets + setns -- reading the sign of values via flags
;
; Demonstrates: setcc driven by SF (with test as the flag setter)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_142.lst ch07_142_sets_setns.asm && ld -g -o ch07_142_sets_setns ch07_142_sets_setns.o
; Run:    ./ch07_142_sets_setns ; echo $?        -> exit code: 2
;
; test value,value loads SF with the value's sign: sets returns 1 for
; negatives, setns 1 for non-negatives.  -1 -> 1, +5 -> 1, sum 2.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    xor     rax, rax                   ; accumulator

    mov     rbx, -1
    xor     rcx, rcx                   ; zero destination BEFORE test
    test    rbx, rbx                   ; SF = 1
    sets    cl                         ; cl = 1 (negative)
    add     rax, rcx                   ; rax = 1

    mov     rbx, 5
    xor     rcx, rcx
    test    rbx, rbx                   ; SF = 0
    setns   cl                         ; cl = 1 (non-negative)
    add     rax, rcx                   ; rax = 2

last:
    mov     rdi, rax                   ; exit status = 2
    mov     rax, SYS_exit
    syscall
