; -----------------------------------------------------------------------------
; SAR vs SHR on -1 (byte): 0xFF sar 4 -> 0xFF (255), shr 4 -> 0x0F (15)
;
; Demonstrates: the difference between the arithmetic and logical right
;               shifts applied to the same negative byte
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_101.lst ch07_101_sar_vs_shr_neg.asm && ld -g -o ch07_101 ch07_101_sar_vs_shr_neg.o
; Run:    ./ch07_101 ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Both bytes start at 0xFF = -1 (signed).  Shifting right by four:
;   SAR copies the sign bit in -> still 1111 1111 = 0xFF (255):
;       mathematically -1 / 16 rounds toward minus infinity, staying -1.
;   SHR moves 0s in from the top -> 0000 1111 = 0x0F (15):
;       the top nibble becomes 0 whatever the sign bit was.
    mov     al, 0xFF                    ; al = 1111 1111 (-1 signed)
    mov     bl, al                      ; identical starting byte
    sar     bl, 4                       ; bl = 1111 1111 = 255 (sign-filled)
    shr     al, 4                       ; al = 0000 1111 = 15  (zero-filled)

; Exit with the SHR result; the SAR result (255) stays in bl for
; inspection under a debugger.
;
; Note: the contrast is visible in the low bits only -- for a full qword,
; (-1 shr 4) = 0x0FFFFFFFFFFFFFFF still ends in 0xFF because ones shift
; down from the upper bits; the zeros appear only at the very top.
    movzx   rdi, al                     ; exit status = 15 (the SHR result)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall
