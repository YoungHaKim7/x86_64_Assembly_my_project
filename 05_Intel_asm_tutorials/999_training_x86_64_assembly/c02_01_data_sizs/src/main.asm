; -----------------------------------------------------------------------------
; Data sizes: db, dw, dd, dq occupy consecutive addresses
;
; Demonstrates: consecutive data declarations, label addresses, sub on addresses
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 2.2 (Data Storage Sizes)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch02_01_data_sizes.lst ch02_01_data_sizes.asm && ld -g -o ch02_01_data_sizes ch02_01_data_sizes.o
; Run:    ./ch02_01_data_sizes ; echo $?        -> exit code: 8
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVar1       db  0x11                    ; byte  variable (1 byte)
    wVar1       dw  0x2222                  ; word  variable (2 bytes, 1 past bVar1)
    dVar1       dd  0x33333333              ; dword variable (4 bytes, 2 past wVar1)
    qVar1       dq  0x4444444444444444      ; qword variable (8 bytes, 4 past dVar1)
qEnd:                                       ; label placed right after the qword

section .text
global main
main:

; each size is the distance between the addresses of adjacent declarations
    mov     rcx, wVar1                      ; rcx = address of the word
    mov     rdx, bVar1                      ; rdx = address of the byte
    sub     rcx, rdx                        ; rcx = 1  -> db reserves 1 byte

    mov     r8, dVar1                       ; r8  = address of the dword
    mov     rdx, wVar1                      ; rdx = address of the word
    sub     r8, rdx                         ; r8  = 2  -> dw reserves 2 bytes

    mov     r9, qVar1                       ; r9  = address of the qword
    mov     rdx, dVar1                      ; rdx = address of the dword
    sub     r9, rdx                         ; r9  = 4  -> dd reserves 4 bytes

    mov     rax, qEnd                       ; rax = address just past the qword
    mov     rdx, qVar1                      ; rdx = address of the qword
    sub     rax, rdx                        ; rax = 8  -> dq reserves 8 bytes

last:
    mov     rdi, rax                        ; exit code: qword size (8)
    mov     rax, SYS_exit                   ; call code for exit
    syscall
