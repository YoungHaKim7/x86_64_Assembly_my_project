; -----------------------------------------------------------------------------
; unlink -- deleting a file, and proving it is gone
;
; Demonstrates: SYS_unlink (87) and open() failing on a missing path
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.5 - 13.9 (File Operations)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_23.lst ch13_23_file_unlink.asm && ld -g -o ch13_23_file_unlink ch13_23_file_unlink.o
; Run:    ./ch13_23_file_unlink ; echo $?          -> 1
;
; Errors are reported by negative rax (-ENOENT = -2 here).  The final open
; must fail; its failure IS the success condition of the demo.
; -----------------------------------------------------------------------------

SYS_open         equ 2
SYS_close        equ 3
SYS_unlink       equ 87
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
O_RDONLY         equ 0
O_WRONLY         equ 1
O_CREAT          equ 64

section .data
    fileName    db  "ch13_tmp5.txt", 0

section .text
global _start
_start:
    ; ---- create and close a throwaway file ----------------------------------
    mov     rax, SYS_open
    mov     rdi, fileName
    mov     rsi, O_CREAT | O_WRONLY
    mov     rdx, 0644o
    syscall
    mov     r12, rax
    mov     rax, SYS_close
    mov     rdi, r12
    syscall

    ; ---- delete it -----------------------------------------------------------
    mov     rax, SYS_unlink
    mov     rdi, fileName
    syscall

    ; ---- try to open it again: this must FAIL (negative rax) -----------------
    mov     rax, SYS_open
    mov     rdi, fileName
    mov     rsi, O_RDONLY
    xor     rdx, rdx
    syscall

    test    rax, rax                   ; sign flag set by negative errno
    js      gone                        ; negative -> file really gone
    mov     rbx, 0                      ; unexpected: open succeeded?!
    jmp     last
gone:
    mov     rbx, 1                      ; verified: unlink removed the file

last:
    mov     rdi, rbx                    ; exit status = 1
    mov     rax, SYS_exit
    syscall
