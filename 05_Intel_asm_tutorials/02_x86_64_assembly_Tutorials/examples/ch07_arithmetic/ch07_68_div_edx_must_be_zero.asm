; -----------------------------------------------------------------------------
; div: edx MUST be zeroed before a double-word divide (avoiding the #DE trap)
;
; Demonstrates: the divide-error hazard of a garbage high dividend half,
;               and the correct xor edx, edx / mov edx, 0 idiom
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_68.lst ch07_68_div_edx_must_be_zero.asm && ld -g -o ch07_68 ch07_68_div_edx_must_be_zero.o
; Run:    ./ch07_68 ; echo $?        -> exit code: 50
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; div ebx divides the 64-bit value edx:eax by ebx.  If edx still holds
; leftovers from earlier code, the dividend becomes huge and the true
; quotient will not fit in eax; the CPU then raises a divide-error
; exception (#DE, vector 0) and Linux kills the process with SIGFPE.
; Clearing the high half immediately before the divide is mandatory:
    mov     eax, 500                    ; eax = dividend low half (500)
    mov     ebx, 10                     ; ebx = divisor
    mov     edx, 0                      ; edx = 0 -- NOT optional!
    div     ebx                         ; eax = 500/10 = 50, edx = 0

; (Contrast: with edx = 1 the dividend would be 2^32 + 500; dividing by 10
; gives a quotient near 429 million, which still fits -- but anything
; larger, e.g. edx = 10, overflows eax and faults.  Always clear it.)

    movzx   edi, al                     ; exit status = quotient (50)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (50)
