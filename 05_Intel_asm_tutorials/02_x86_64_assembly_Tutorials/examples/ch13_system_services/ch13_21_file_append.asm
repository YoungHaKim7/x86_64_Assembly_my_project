; -----------------------------------------------------------------------------
; Appending to a file -- O_APPEND positions every write at the end
;
; Demonstrates: O_APPEND flag semantics
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.5 - 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_21.lst ch13_21_file_append.asm && ld -g -o ch13_21_file_append ch13_21_file_append.o
; Run:    ./ch13_21_file_append
;         -> ABCD        (file held "AB", then "CD" was appended)
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_write        equ 1
SYS_open         equ 2
SYS_close        equ 3
SYS_unlink       equ 87
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
O_RDONLY         equ 0
O_WRONLY         equ 1
O_CREAT          equ 64
O_APPEND         equ 1024

section .data
    fileName    db  "ch13_tmp3.txt", 0
    firstPart   db  "AB"
    firstLen    equ $-firstPart
    nextPart    db  "CD"
    nextLen     equ $-nextPart

section .bss
    inBuf       resb 64

section .text
global _start
_start:
    ; ---- create with "AB" ---------------------------------------------------
    mov     rax, SYS_open
    mov     rdi, fileName
    mov     rsi, O_CREAT | O_WRONLY
    mov     rdx, 0644o
    syscall
    mov     r12, rax
    mov     rax, SYS_write
    mov     rdi, r12
    mov     rsi, firstPart
    mov     rdx, firstLen
    syscall
    mov     rax, SYS_close
    mov     rdi, r12
    syscall

    ; ---- reopen with O_APPEND, write "CD" -----------------------------------
    mov     rax, SYS_open
    mov     rdi, fileName
    mov     rsi, O_WRONLY | O_APPEND   ; writes now go to the end
    xor     rdx, rdx
    syscall
    mov     r12, rax
    mov     rax, SYS_write
    mov     rdi, r12
    mov     rsi, nextPart
    mov     rdx, nextLen
    syscall
    mov     rax, SYS_close
    mov     rdi, r12
    syscall

    ; ---- read back and print -------------------------------------------------
    mov     rax, SYS_open
    mov     rdi, fileName
    mov     rsi, O_RDONLY
    xor     rdx, rdx
    syscall
    mov     r12, rax
    mov     rax, SYS_read
    mov     rdi, r12
    mov     rsi, inBuf
    mov     rdx, 64
    syscall                             ; rax = 4 ("ABCD")
    mov     byte [inBuf + rax], 10      ; append newline for the demo
    inc     rax
    mov     rdx, rax
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, inBuf
    syscall                             ; prints "ABCD\n" 
    mov     rax, SYS_close
    mov     rdi, r12
    syscall

    mov     rax, SYS_unlink
    mov     rdi, fileName
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
