; -----------------------------------------------------------------------------
; Mixing byte, word and dword variables
;
; Demonstrates: movzx widening loads so different sizes can be added
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 4.4 (Data Section)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch04_06_mixed_sizes.lst ch04_06_mixed_sizes.asm && ld -g -o ch04_06_mixed_sizes ch04_06_mixed_sizes.o
; Run:    ./ch04_06_mixed_sizes ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db 85                        ; byte  variable
    wVar1       dw 85                        ; word  variable
    dVar1       dd 85                        ; dword variable

section .text
global _start
_start:

    movzx   eax, byte [bVar1]                ; eax = 85
    movzx   ecx, word [wVar1]                ; ecx = 85
    add     eax, ecx                         ; eax = 170
    add     eax, dword [dVar1]               ; eax = 255: 85 + 85 + 85

    movzx   rdi, al                          ; exit code 255

last:
    mov     rax, SYS_exit                    ; call code for exit
    syscall
