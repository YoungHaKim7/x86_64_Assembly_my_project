; -----------------------------------------------------------------------------
; Two's complement identity: NOT(d) + 1 == -d  (dword)
;
; Demonstrates: not, add, neg, cmp with dword operands
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 3.1.1 (Two's Complement)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch03_03_twos_complement_dword.lst ch03_03_twos_complement_dword.asm && ld -g -o ch03_03_twos_complement_dword ch03_03_twos_complement_dword.o
; Run:    ./ch03_03_twos_complement_dword ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dVar1       dd 7                        ; the dword to negate

section .text
global _start
_start:

; route 1: invert every bit, then add one
    mov     eax, dword [dVar1]              ; eax = 7
    not     eax                             ; eax = 0xFFFFFFF8 (~7)
    add     eax, 1                          ; eax = 0xFFFFFFF9 (~7 + 1)

; route 2: hardware negate
    mov     ecx, dword [dVar1]              ; ecx = 7
    neg     ecx                             ; ecx = 0xFFFFFFF9 (-7)

    cmp     eax, ecx                        ; both routes equal?
    mov     rdi, 0                          ; result 0 if they differ
    jne     last
    mov     rdi, 1                          ; identical: NOT(d) + 1 == -d

last:
    mov     rax, SYS_exit                   ; call code for exit
    syscall
