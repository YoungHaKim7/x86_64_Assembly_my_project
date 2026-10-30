; -----------------------------------------------------------------------------
; movss -- storing an XMM register back to memory
;
; Demonstrates: xmm -> memory round trip preserves the value exactly
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 18.3 (Data Movement)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch18_04.lst ch18_04_movss_store.asm && ld -g -o ch18_04_movss_store ch18_04_movss_store.o
; Run:    ./ch18_04_movss_store ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    fltSrc      dd  7.5

section .bss
    fltDst      resd 1                  ; landing slot

section .text
global _start
_start:
    movss   xmm0, dword [fltSrc]       ; load
    movss   dword [fltDst], xmm0       ; store
    movss   xmm1, dword [fltDst]       ; reload from memory

    comiss  xmm0, xmm1                 ; round trip identical?
    je      equal
    xor     rax, rax
    jmp     last
equal:
    mov     rax, 1

last:
    mov     rdi, rax                    ; exit status = 1
    mov     rax, SYS_exit
    syscall
