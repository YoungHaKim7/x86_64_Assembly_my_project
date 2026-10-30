; -----------------------------------------------------------------------------
; fork() twice -- two children with different exit codes, parent waits for both
;
; Demonstrates: multiple fork() calls, two wait4() calls, summing exit codes
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 19.2 (Multiprocessing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch19_02.lst ch19_02_fork_two_children.asm && ld -g -o ch19_02_fork_two_children ch19_02_fork_two_children.o
; Run:    ./ch19_02_fork_two_children ; echo $?        -> exit code: 30
;
; Child A exits 10, child B exits 20.  The parent waits for BOTH children
; and exits with 10 + 20 = 30.  Note each child must not fall through into
; the second fork -- it exits immediately after its own work.
; -----------------------------------------------------------------------------

SYS_fork         equ 57
SYS_wait4        equ 61
SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .bss
    wStatus     resd 1

section .text
global _start
_start:

; ---- child A: fork then exit 10 -----------------------------------------
    mov     rax, SYS_fork
    syscall
    cmp     rax, 0
    jne     forkB                       ; parent continues below
    mov     rax, SYS_exit               ; -- child A --
    mov     rdi, 10
    syscall

; ---- child B: fork then exit 20 -----------------------------------------
forkB:
    mov     rax, SYS_fork
    syscall
    cmp     rax, 0
    jne     waitBoth                    ; parent continues below
    mov     rax, SYS_exit               ; -- child B --
    mov     rdi, 20
    syscall

; ---- parent: wait for both children, sum their exit codes ---------------
waitBoth:
    xor     r12, r12                    ; r12 = running sum of exit codes

    mov     rax, SYS_wait4              ; first wait4: one of the children
    mov     rdi, -1
    mov     rsi, wStatus
    xor     rdx, rdx
    xor     r10, r10
    syscall
    mov     eax, dword [wStatus]
    shr     eax, 8
    and     eax, 0xFF
    add     r12, rax                    ; += first child's code

    mov     rax, SYS_wait4              ; second wait4: the other child
    mov     rdi, -1
    mov     rsi, wStatus
    xor     rdx, rdx
    xor     r10, r10
    syscall
    mov     eax, dword [wStatus]
    shr     eax, 8
    and     eax, 0xFF
    add     r12, rax                    ; += second child's code (10+20=30)

last:
    mov     rdi, r12                    ; exit status = 30
    mov     rax, SYS_exit
    syscall
