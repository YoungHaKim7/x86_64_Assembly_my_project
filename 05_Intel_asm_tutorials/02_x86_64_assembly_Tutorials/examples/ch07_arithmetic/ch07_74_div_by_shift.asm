; -----------------------------------------------------------------------------
; Divide by a power of two with a shift: 200 shr 2 = 50
;
; Demonstrates: unsigned division by 2^k using shr (strength reduction),
;               contrast with sar for signed operands
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_74.lst ch07_74_div_by_shift.asm && ld -g -o ch07_74 ch07_74_div_by_shift.o
; Run:    ./ch07_74 ; echo $?        -> exit code: 50
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Shift every bit right by k positions and you divide the value by 2^k.
; shr (shift logical right) shifts in ZEROS, which is correct for UNSIGNED
; values; sar (shift arithmetic right) would replicate the sign bit and is
; the one to use for signed values.
    mov     rax, 200                    ; rax = 200 (unsigned dividend)
    shr     rax, 2                      ; rax = 200 / 2^2 = 200 / 4 = 50

; Same answer a real div would give (quotient truncation and zero-fill
; agree for unsigned values).  shr is one short instruction with no
; rdx pre-clearing and no divide-fault hazard.
    movzx   edi, al                     ; exit status = 50

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (50)
