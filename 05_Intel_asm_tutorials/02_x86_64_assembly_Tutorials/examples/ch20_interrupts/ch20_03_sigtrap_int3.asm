; -----------------------------------------------------------------------------
; Breakpoint interrupt -- int3 raises SIGTRAP (5)
;
; Demonstrates: int3 software breakpoint instruction, signal observation
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 20.2 - 20.3 (Interrupt Levels)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch20_03.lst ch20_03_sigtrap_int3.asm && ld -g -o ch20_03_sigtrap_int3 ch20_03_sigtrap_int3.o
; Run:    ./ch20_03_sigtrap_int3 ; echo $?        -> exit code: 5
;
; int3 is the single-byte breakpoint trap (opcode 0xCC) debuggers plant in
; code.  Executed outside a debugger it raises exception 3 (#BP); the
; kernel maps it to SIGTRAP (5) and terminates the process.  Running the
; trap in a child keeps the demo alive: the parent wait4()s and reports
; signal 5 from the status word.
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

; ---- child: execute the breakpoint trap ---------------------------------
    mov     rax, SYS_fork
    syscall
    cmp     rax, 0
    jne     parentRun

    nop                               ; some context before the trap
    int3                              ; breakpoint interrupt -> SIGTRAP (5)
    ; ---- unreachable: child died at int3 -------------------------------
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall

; ---- parent: report which signal killed the child -----------------------
parentRun:
    mov     rax, SYS_wait4
    mov     rdi, -1
    mov     rsi, wStatus
    xor     rdx, rdx
    xor     r10, r10
    syscall

    mov     eax, dword [wStatus]
    and     eax, 0x7F                  ; WTERMSIG -> 5 (SIGTRAP)

last:
    mov     rdi, rax                   ; exit status = 5
    mov     rax, SYS_exit
    syscall
