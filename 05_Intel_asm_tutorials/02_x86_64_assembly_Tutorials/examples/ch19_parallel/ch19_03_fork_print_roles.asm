; -----------------------------------------------------------------------------
; fork() -- each process announces its role on stdout
;
; Demonstrates: SYS_fork, SYS_write from two different processes
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 19.2 (Multiprocessing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch19_03.lst ch19_03_fork_print_roles.asm && ld -g -o ch19_03_fork_print_roles ch19_03_fork_print_roles.o
; Run:    ./ch19_03_fork_print_roles
;         -> prints two lines (order not deterministic):
;            child
;            parent
;
; After fork() both processes run the same image.  The return value in rax
; tells them apart: 0 in the child, the child's pid in the parent.  Each
; branch writes its own message.  The parent wait4()s so it cannot exit
; before the child has finished writing.
; -----------------------------------------------------------------------------

SYS_write         equ 1
SYS_fork          equ 57
SYS_wait4         equ 61
SYS_exit          equ 60
EXIT_SUCCESS      equ 0
STDOUT            equ 1

section .data
    childMsg    db  "child", 10         ; child's line (10 = newline)
    childLen    equ $-childMsg
    parentMsg   db  "parent", 10        ; parent's line
    parentLen   equ $-parentMsg

section .bss
    wStatus     resd 1

section .text
global _start
_start:

    mov     rax, SYS_fork               ; split into two processes
    syscall
    cmp     rax, 0
    je      childRun

; ---- parent branch -------------------------------------------------------
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, parentMsg
    mov     rdx, parentLen
    syscall

    mov     rax, SYS_wait4              ; let the child finish before exiting
    mov     rdi, -1
    mov     rsi, wStatus
    xor     rdx, rdx
    xor     r10, r10
    syscall
    jmp     last

; ---- child branch --------------------------------------------------------
childRun:
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, childMsg
    mov     rdx, childLen
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
