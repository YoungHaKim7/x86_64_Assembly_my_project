; -----------------------------------------------------------------------------
; Create a file and write text into it
;
; Demonstrates: SYS_open with O_CREAT|O_WRONLY, SYS_write to fd, SYS_close
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.5 - 13.7 (File Open/Read/Write)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_19.lst ch13_19_file_create_write.asm && ld -g -o ch13_19_file_create_write ch13_19_file_create_write.o
; Run:    ./ch13_19_file_create_write ; echo $?          -> 0
;         cat ch13_tmp.txt                             -> file data
;         (the program removes the file at the end; uncomment the final
;          unlink block to keep it)
;
; open(path, O_CREAT|O_WRONLY, 0644): rdi=path rsi=flags rdx=mode -> rax=fd
; -----------------------------------------------------------------------------

SYS_close        equ 3
SYS_open         equ 2
SYS_write        equ 1
SYS_unlink       equ 87
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
O_WRONLY         equ 1
O_CREAT          equ 64

section .data
    fileName    db  "ch13_tmp.txt", 0  ; NUL-terminated path
    fileData    db  "file data", 10
    dataLen     equ $-fileData

section .text
global _start
_start:
    mov     rax, SYS_open
    mov     rdi, fileName
    mov     rsi, O_CREAT | O_WRONLY    ; create if missing, write-only
    mov     rdx, 0644o                 ; owner rw, group/other r
    syscall
    mov     r12, rax                   ; keep the fd

    mov     rax, SYS_write
    mov     rdi, r12
    mov     rsi, fileData
    mov     rdx, dataLen
    syscall

    mov     rax, SYS_close             ; flush and release the descriptor
    mov     rdi, r12
    syscall

    mov     rax, SYS_unlink            ; clean up: remove the file
    mov     rdi, fileName
    syscall

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
