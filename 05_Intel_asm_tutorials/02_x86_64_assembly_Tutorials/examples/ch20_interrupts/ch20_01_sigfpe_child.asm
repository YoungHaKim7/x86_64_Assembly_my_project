; -----------------------------------------------------------------------------
; Hardware interrupt demo -- integer divide error raises SIGFPE (8)
;
; Demonstrates: CPU exception -> kernel signal, observed from a parent process
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 20.2 - 20.3 (Interrupt Types/Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch20_01.lst ch20_01_sigfpe_child.asm && ld -g -o ch20_01_sigfpe_child ch20_01_sigfpe_child.o
; Run:    ./ch20_01_sigfpe_child ; echo $?        -> exit code: 8
;
; A division by zero is not an "error return" -- the CPU raises exception
; interrupt 0 (#DE) and the kernel converts it to SIGFPE, killing the process.
; The division runs in a CHILD process so the demonstration is survivable:
; the parent wait4()s and reads the signal number from status bits 0..6,
; which is 8 (SIGFPE).  Try changing the divisor to see exit 1 instead.
; -----------------------------------------------------------------------------

SYS_fork          equ 57
SYS_wait4         equ 61
SYS_exit          equ 60
EXIT_SUCCESS      equ 0

section .data
    qDividend  dq 12345                 ; numerator
    qDivisor   dq 0                     ; denominator -- zero on purpose!

section .bss
    wStatus      resd 1

section .text
global _start
_start:

; ---- child: perform the faulting division -------------------------------
    mov     rax, SYS_fork
    syscall
    cmp     rax, 0
    jne     parentRun

    mov     rax, qword [qDividend]
    xor     rdx, rdx                    ; rdx:rax = dividend (must be 0)
    idiv    qword [qDivisor]            ; divide by zero -> #DE -> SIGFPE
    ; ---- unreachable: the process dies at idiv ---------------------------
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall

; ---- parent: collect the signal number ----------------------------------
parentRun:
    mov     rax, SYS_wait4
    mov     rdi, -1
    mov     rsi, wStatus
    xor     rdx, rdx
    xor     r10, r10
    syscall

    mov     eax, dword [wStatus]
    and     eax, 0x7F                   ; WTERMSIG: bits 0..6 = signal number
                                        ; 8 == SIGFPE (floating point exception)

last:
    mov     rdi, rax                    ; exit status = 8
    mov     rax, SYS_exit
    syscall
