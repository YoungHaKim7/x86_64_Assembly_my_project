; -----------------------------------------------------------------------------
; Signed vs unsigned byte multiply: 0xFE * 2 as mul (254*2) and imul (-2*2)
;
; Demonstrates: same bit pattern, different interpretation -- the low byte
;               of the product is identical either way
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_63.lst ch07_63_signed_vs_unsigned_mul.asm && ld -g -o ch07_63 ch07_63_signed_vs_unsigned_mul.o
; Run:    ./ch07_63 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bBits       db 0xFE                  ; bit pattern 11111110
    bTwo        db 2                     ; multiplier for both paths

section .text
global _start
_start:

; --- Unsigned path: mul treats 0xFE as 254 -------------------------------
    mov     al, byte [bBits]            ; al = 0xFE (= 254 unsigned)
    mov     bl, byte [bTwo]             ; bl = 2
    mul     bl                          ; ax = 254 * 2 = 508 = 0x01FC
    mov     cl, al                      ; cl = low byte of 508 = 0xFC (252)

; --- Signed path: imul treats the same 0xFE as -2 ------------------------
    mov     al, byte [bBits]            ; al = 0xFE (= -2 signed)
    mov     bl, byte [bTwo]             ; bl = 2
    imul    bl                          ; ax = -2 * 2 = -4 = 0xFFFC
    mov     dl, al                      ; dl = low byte of -4 = 0xFC (252)

; 508 and -4 differ wildly as numbers, but their bit patterns share the
; same low byte (0xFC = 252): the low 8 bits of any product depend only
; on the low 8 bits of the operands, signed or not.
    mov     edi, EXIT_SUCCESS           ; status 0 if the bytes differ
    cmp     cl, dl                      ; unsigned low byte vs signed low byte
    jne     last                        ; mismatch (never taken here)

    mov     edi, 1                      ; equal -> status 1

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1 = equal)
