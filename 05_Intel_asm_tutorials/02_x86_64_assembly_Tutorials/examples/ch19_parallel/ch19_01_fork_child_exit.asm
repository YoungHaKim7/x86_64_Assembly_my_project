; -----------------------------------------------------------------------------
; fork() -- child exits with its own code, parent collects it via wait4()
;
; Demonstrates: SYS_fork (57), SYS_wait4 (61), WEXITSTATUS decoding
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 19.2 (Multiprocessing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch19_01.lst ch19_01_fork_child_exit.asm && ld -g -o ch19_01_fork_child_exit ch19_01_fork_child_exit.o
; Run:    ./ch19_01_fork_child_exit ; echo $?        -> exit code: 42
;
; The child process exits 42.  The parent wait4()s for it, then extracts
; the child's exit code from the upper 8 bits of the status word and exits
; with that same value -- proving the value crossed the process boundary.
; -----------------------------------------------------------------------------

SYS_fork         equ 57                  ; fork syscall
SYS_wait4        equ 61                  ; wait4 syscall
SYS_exit         equ 60                  ; exit syscall
EXIT_SUCCESS     equ 0

section .bss
    wStatus     resd 1                  ; wait4() writes the child status here

section .text
global _start
_start:

; ---- create the child process ------------------------------------------
    mov     rax, SYS_fork               ; rax = 57
    syscall                             ; child gets rax=0, parent gets pid
    cmp     rax, 0
    jne     parentRun                   ; nonzero -> we are the parent

; ---- child: exit immediately with 42 ------------------------------------
childRun:
    mov     rax, SYS_exit
    mov     rdi, 42                     ; child's exit code
    syscall

; ---- parent: wait for the child, then report its exit code --------------
parentRun:
    mov     rax, SYS_wait4              ; wait4(pid=-1, &status, 0, NULL)
    mov     rdi, -1                     ; any child
    mov     rsi, wStatus                ; status lands here
    xor     rdx, rdx                    ; no options
    xor     r10, r10                    ; no rusage
    syscall

    mov     eax, dword [wStatus]
    shr     eax, 8                      ; WEXITSTATUS: bits 8..15
    and     eax, 0xFF                   ; keep one byte

last:
    mov     rdi, rax                    ; exit status = child's exit code (42)
    mov     rax, SYS_exit
    syscall
