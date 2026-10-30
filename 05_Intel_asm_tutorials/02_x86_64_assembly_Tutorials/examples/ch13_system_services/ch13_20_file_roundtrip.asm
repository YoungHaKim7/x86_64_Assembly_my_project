; -----------------------------------------------------------------------------
; File round trip -- write, close, reopen, read, print
;
; Demonstrates: full create/write/reopen/read cycle with error checks
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.5 - 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_20.lst ch13_20_file_roundtrip.asm && ld -g -o ch13_20_file_roundtrip ch13_20_file_roundtrip.o
; Run:    ./ch13_20_file_roundtrip
;         -> round trip
; -----------------------------------------------------------------------------

SYS_read         equ 0
SYS_write        equ 1
SYS_open         equ 2
SYS_close        equ 3
SYS_unlink       equ 87
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDIN            equ 0
STDOUT           equ 1
O_RDONLY         equ 0
O_WRONLY         equ 1
O_CREAT          equ 64

section .data
    fileName    db  "ch13_tmp2.txt", 0
    outData     db  "round trip", 10
    outLen      equ $-outData

section .bss
    inBuf       resb 64

section .text
global _start
_start:
    ; ---- create and write --------------------------------------------------
    mov     rax, SYS_open
    mov     rdi, fileName
    mov     rsi, O_CREAT | O_WRONLY
    mov     rdx, 0644o
    syscall
    mov     r12, rax                   ; write fd

    mov     rax, SYS_write
    mov     rdi, r12
    mov     rsi, outData
    mov     rdx, outLen
    syscall

    mov     rax, SYS_close
    mov     rdi, r12
    syscall

    ; ---- reopen read-only ---------------------------------------------------
    mov     rax, SYS_open
    mov     rdi, fileName
    mov     rsi, O_RDONLY
    xor     rdx, rdx
    syscall
    mov     r12, rax                   ; read fd

    mov     rax, SYS_read
    mov     rdi, r12
    mov     rsi, inBuf
    mov     rdx, 64
    syscall                             ; rax = bytes read (11)

    mov     rdx, rax                   ; echo to stdout
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, inBuf
    syscall

    mov     rax, SYS_close
    mov     rdi, r12
    syscall

    mov     rax, SYS_unlink            ; leave no file behind
    mov     rdi, fileName
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
