; -----------------------------------------------------------------------------
; wait4() status word -- separating "exited" from "was killed"
;
; Demonstrates: SYS_wait4 status bits: WIFEXITED, WEXITSTATUS
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 19.2 (Multiprocessing)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch19_04.lst ch19_04_waitpid_wexitstatus.asm && ld -g -o ch19_04_waitpid_wexitstatus ch19_04_waitpid_wexitstatus.o
; Run:    ./ch19_04_waitpid_wexitstatus ; echo $?        -> exit code: 8
;                                                       (1 = exited normally,
;                                                        +7 = child's code)
;
; The wait4() status word packs the outcome:
;   bits  0..7  : signal number if killed (0 = normal exit)
;   bits 8..15  : exit code if the process exited normally
; The child here exits 7, so the parent reads (status >> 8) & 0xFF == 7
; and verifies the low byte is 0 (not signaled) before trusting the code.
; -----------------------------------------------------------------------------

SYS_fork          equ 57
SYS_wait4         equ 61
SYS_exit          equ 60
EXIT_SUCCESS      equ 0

section .bss
    wStatus      resd 1

section .text
global _start
_start:

; ---- child: exit with code 7 ---------------------------------------------
    mov     rax, SYS_fork
    syscall
    cmp     rax, 0
    jne     parentRun
    mov     rax, SYS_exit
    mov     rdi, 7                      ; child's chosen exit code
    syscall

; ---- parent: wait, decode the status word -------------------------------
parentRun:
    mov     rax, SYS_wait4
    mov     rdi, -1
    mov     rsi, wStatus
    xor     rdx, rdx
    xor     r10, r10
    syscall

    mov     eax, dword [wStatus]
    test    al, al                      ; WIFEXITED: low byte 0 -> normal exit
    jnz     badStatus                   ; signaled children have bits 0..6 set
    mov     ebx, 1                      ; result flag: exited normally

    shr     eax, 8                      ; WEXITSTATUS: the child's code
    and     eax, 0xFF
    add     rbx, rax                    ; 1 + 7 = 8: flag plus the code
    jmp     last

badStatus:
    mov     ebx, 0                      ; child died from a signal

last:
    mov     rdi, rbx                    ; 8 = exited(1) + exit code 7
    mov     rax, SYS_exit
    syscall
