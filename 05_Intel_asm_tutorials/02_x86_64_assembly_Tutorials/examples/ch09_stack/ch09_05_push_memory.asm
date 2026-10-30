; -----------------------------------------------------------------------------
; pushing memory: push qword [qVar] then pop it into a register
;
; Demonstrates: push/pop of a memory operand (no register round trip needed)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.2 (Stack Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_05_push_memory.lst ch09_05_push_memory.asm && ld -g -o ch09_05_push_memory ch09_05_push_memory.o
; Run:    ./ch09_05_push_memory ; echo $?        -> exit code: 63
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qVar        dq 63                      ; qword to send through the stack

section .text
global _start
_start:

; push accepts a memory operand directly: the CPU reads the qword at qVar
; and stores it at rsp-8.  The pop side delivers it into rax -- memory to
; register by way of the stack, without touching any other register.
    push    qword [qVar]                   ; stack: [qVar] = 63
    pop     rax                            ; rax = 63

    mov     rdi, rax                       ; exit code = 63

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
