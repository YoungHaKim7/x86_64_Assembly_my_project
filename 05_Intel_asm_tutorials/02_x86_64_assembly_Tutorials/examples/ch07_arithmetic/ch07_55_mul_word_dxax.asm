; -----------------------------------------------------------------------------
; mul (word form): 300 * 400 = 120000, product split across dx:ax
;
; Demonstrates: unsigned word multiply mul, 32-bit product in dx:ax
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_55.lst ch07_55_mul_word_dxax.asm && ld -g -o ch07_55 ch07_55_mul_word_dxax.o
; Run:    ./ch07_55 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    wVal1       dw 300                  ; word multiplicand
    wVal2       dw 400                  ; word multiplier

section .text
global _start
_start:

; For the word form of mul the multiplicand MUST be in ax.  The product of
; two words can need up to 32 bits, so it is placed in the dx:ax register
; pair:  dx holds the high word, ax the low word.
    mov     ax, word [wVal1]            ; ax = 300 (multiplicand, must be ax)
    mov     bx, word [wVal2]            ; bx = 400 (multiplier)
    mul     bx                          ; dx:ax = 300 * 400 = 120000

; 120000 decimal = 0x0001D4C0, which does NOT fit in 16 bits:
;   dx = 0x0001  (high word = 1)
;   ax = 0xD4C0  (low word)
; The non-zero dx shows the word product "overflowed" into the double-width
; result -- exactly what the dx:ax pair is for.
    movzx   edi, dx                     ; exit status = high word (1)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1)
