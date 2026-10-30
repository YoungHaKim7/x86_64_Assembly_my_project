; -----------------------------------------------------------------------------
; 2-D array row sum: sum row 1 ({4,5,6}) of a 3x3 dword matrix = 15
;
; Demonstrates: row-major layout, skipping to a row with base+displacement
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.2 (Addressing Mode Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_16_2d_row_sum.lst ch08_16_2d_row_sum.asm && ld -g -o ch08_16_2d_row_sum ch08_16_2d_row_sum.o
; Run:    ./ch08_16_2d_row_sum ; echo $?        -> exit code: 15
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    COLS        equ 3                      ; columns per row
    ROW_SIZE    equ COLS*4                 ; bytes per row (3 dwords)
    matrix      dd 1, 2, 3                 ; row 0
                dd 4, 5, 6                 ; row 1
                dd 7, 8, 9                 ; row 2

section .text
global _start
_start:

; Row-major storage: the whole matrix is one flat dword list, so row 1
; begins at matrix + 1*ROW_SIZE = matrix + 12 bytes.  Add that displacement
; to a base pointer, then walk COLS dwords (4 bytes each) summing them.
    mov     rsi, matrix                    ; rsi -> matrix[0][0]
    add     rsi, 1*ROW_SIZE                ; rsi -> matrix[1][0]
    mov     eax, 0                         ; rowSum = 0
    mov     rcx, COLS                      ; rcx = elements in a row

rowLoop:
    add     eax, dword [rsi]               ; rowSum += *rsi
    add     rsi, 4                         ; advance one dword
    loop    rowLoop                        ; dec rcx; repeat while rcx > 0

    mov     edi, eax                       ; exit code = 4+5+6 = 15

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
