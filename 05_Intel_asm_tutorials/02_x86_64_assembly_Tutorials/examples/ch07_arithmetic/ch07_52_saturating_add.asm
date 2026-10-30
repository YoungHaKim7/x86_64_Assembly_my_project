; -----------------------------------------------------------------------------
; saturating add: clamp a byte sum instead of wrapping (200 + 100 -> 255)
;
; Demonstrates: carry-driven saturation -- add + jc used to emulate the
;               "no value may exceed the maximum" policy
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5 (Integer Arithmetic Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_52_saturating_add.lst ch07_52_saturating_add.asm && ld -g -o ch07_52_saturating_add ch07_52_saturating_add.o
; Run:    ./ch07_52_saturating_add ; echo $?        -> exit code: 255
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    bVal1       db 200                    ; first byte addend
    bVal2       db 100                    ; second byte addend

section .text
global _start
_start:

; 200 + 100 = 300, which exceeds the unsigned byte maximum of 255:
; a plain add would wrap to 300 - 256 = 44 and silently lose the overflow.
; A saturating add instead pins the result at the maximum, 255.
    mov     al, byte [bVal1]              ; al = 200
    add     al, byte [bVal2]              ; al = 44 (wrapped), CF = 1
    jc      saturate                      ; carry -> result exceeded 255

; no carry path: al already holds the true sum (<= 255)
    jmp     done

saturate:
    mov     al, 255                       ; clamp to the byte maximum

done:
    mov     rdi, 0                        ; clear rdi (only al holds data)
    mov     dil, al                       ; rdi = 255 (saturated)

last:
    mov     rax, SYS_exit                 ; call code for exit
    syscall
