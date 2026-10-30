; -----------------------------------------------------------------------------
; Software interrupt demo -- alarm() timer raises SIGALRM (14)
;
; Demonstrates: SYS_alarm (37), asynchronous signal termination
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 20.1 - 20.3 (Interrupt Processing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch20_02.lst ch20_02_sigalrm_child.asm && ld -g -o ch20_02_sigalrm_child ch20_02_sigalrm_child.o
; Run:    ./ch20_02_sigalrm_child ; echo $?        -> exit code: 14
;
; The child arms a 1-second alarm, then busy-loops (2^48 decrements takes
; far longer than a second).  When the timer fires the kernel interrupts
; the loop and delivers SIGALRM; with no handler installed the default
; action terminates the child.  The parent wait4()s and reports the
; signal number, 14 (SIGALRM), from status bits 0..6.
; -----------------------------------------------------------------------------

SYS_alarm         equ 37                ; alarm(seconds)
SYS_fork          equ 57
SYS_wait4         equ 61
SYS_exit          equ 60
EXIT_SUCCESS      equ 0

section .bss
    wStatus      resd 1

section .text
global _start
_start:

; ---- child: arm the alarm, then spin ------------------------------------
    mov     rax, SYS_fork
    syscall
    cmp     rax, 0
    jne     parentRun

    mov     rax, SYS_alarm              ; request SIGALRM in 1 second
    mov     rdi, 1
    syscall

    mov     rcx, 0xFFFFFFFFFFFF        ; ~2.8e14 iterations >> 1 second
spinLoop:
    dec     rcx
    cmp     rcx, 0
    jne     spinLoop                    ; interrupted long before this exits

    mov     rax, SYS_exit               ; only reached if the alarm failed
    mov     rdi, EXIT_SUCCESS
    syscall

; ---- parent: wait and report the signal ---------------------------------
parentRun:
    mov     rax, SYS_wait4
    mov     rdi, -1
    mov     rsi, wStatus
    xor     rdx, rdx
    xor     r10, r10
    syscall

    mov     eax, dword [wStatus]
    and     eax, 0x7F                   ; WTERMSIG -> 14 (SIGALRM)

last:
    mov     rdi, rax                    ; exit status = 14
    mov     rax, SYS_exit
    syscall
