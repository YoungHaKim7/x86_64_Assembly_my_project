; -----------------------------------------------------------------------------
; Syscall anatomy -- what every register means
;
; Demonstrates: the x86-64 Linux syscall register convention
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.1 - 13.3 (Calling System Services)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch13_04.lst ch13_04_syscall_anatomy.asm && ld -g -o ch13_04_syscall_anatomy ch13_04_syscall_anatomy.o
; Run:    ./ch13_04_syscall_anatomy
;         -> syscall
;
; Convention for every syscall instruction:
;   rax = service number (1 = write)     rdi = arg 1 (fd: 1 = stdout)
;   rsi = arg 2 (buffer address)         rdx = arg 3 (byte count)
;   r10 = arg 4   r8 = arg 5   r9 = arg 6
;   returns: rax = result (bytes written, or negative errno)
; Only rax/rdi/rsi/rdx are clobbered per the kernel's contract.
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1

section .data
    msg         db  "syscall", 10
    msgLen      equ $-msg

section .text
global _start
_start:
    mov     rax, SYS_write             ; service: write
    mov     rdi, STDOUT                ; arg 1: standard output
    mov     rsi, msg                   ; arg 2: where the bytes are
    mov     rdx, msgLen                ; arg 3: how many bytes
    syscall                             ; kernel does the work, rax = 8

last:
    mov     rax, SYS_exit              ; service: exit
    mov     rdi, EXIT_SUCCESS          ; arg 1: status 0
    syscall
