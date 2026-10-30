; -----------------------------------------------------------------------------
; Writing numbers to a file -- itoa feeding SYS_write to a file fd
;
; Demonstrates: the same itoa works for files and stdout
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.5 - 13.8 (File Operations Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_22.lst ch13_22_file_write_numbers.asm && ld -g -o ch13_22_file_write_numbers ch13_22_file_write_numbers.o
; Run:    ./ch13_22_file_write_numbers
;         -> 1
;            2
;            3           (bytes 1\n2\n3\n written, read back, printed)
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
NL               equ 10

section .data
    fileName    db  "ch13_tmp4.txt", 0

section .bss
    inBuf       resb 64
    tmpBuf      resb 32

section .text
global _start

; ---- writeInt to fd rdi, value rsi ----------------------------------------
writeInt:
    mov     rax, rsi                   ; value
    mov     r8, tmpBuf
    xor     r9, r9
.div:
    xor     rdx, rdx
    mov     rbx, 10
    div     rbx
    add     dl, '0'
    push    rdx
    inc     r9
    test    rax, rax
    jnz     .div
.pop:
    pop     rdx
    mov     byte [r8], dl
    inc     r8
    dec     r9
    jnz     .pop
    mov     byte [r8], NL
    inc     r8
    mov     rdx, r8
    sub     rdx, tmpBuf                ; length incl. newline
    mov     rsi, tmpBuf
    mov     rax, SYS_write
    syscall                             ; rdi (fd) already set
    ret

_start:
    ; ---- create file and write 1,2,3 ----------------------------------------
    mov     rax, SYS_open
    mov     rdi, fileName
    mov     rsi, O_CREAT | O_WRONLY
    mov     rdx, 0644o
    syscall
    mov     r12, rax                   ; file fd

    mov     rdi, r12
    mov     rsi, 1
    call    writeInt
    mov     rdi, r12
    mov     rsi, 2
    call    writeInt
    mov     rdi, r12
    mov     rsi, 3
    call    writeInt

    mov     rax, SYS_close
    mov     rdi, r12
    syscall

    ; ---- read back and print on stdout ---------------------------------------
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
    syscall
    mov     rdx, rax
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, inBuf
    syscall
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
