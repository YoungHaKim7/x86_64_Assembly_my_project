; -----------------------------------------------------------------------------
; 2-D array element: fetch matrix[1][2] = 6 via base + row*COLS*4 + col*4
;
; Demonstrates: computing a 2-D element address and using base+index addressing
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 8.2 (Addressing Mode Examples)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch08_17_2d_element.lst ch08_17_2d_element.asm && ld -g -o ch08_17_2d_element ch08_17_2d_element.o
; Run:    ./ch08_17_2d_element ; echo $?        -> exit code: 6
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    COLS        equ 3                      ; columns per row
    matrix      dd 1, 2, 3                 ; row 0
                dd 4, 5, 6                 ; row 1
                dd 7, 8, 9                 ; row 2

section .text
global _start
_start:

; Row-major address formula for a dword matrix:
;   address = base + row*COLS*4 + col*4
; For [1][2]:  matrix + 1*12 + 2*4 = matrix + 20 -> value 6.
; A memory operand offers only one base plus one (scaled) index register,
; so the row offset and the column offset are first summed into a single
; byte offset, then added to the base by the addressing hardware.
    mov     rbx, matrix                    ; rbx = base address of matrix
    mov     r8, 1                          ; r8 = row index 1
    imul    r8, COLS*4                     ; r8 = row offset = 12 bytes
    mov     r9, 2                          ; r9 = column index 2
    imul    r9, 4                          ; r9 = column offset = 8 bytes
    add     r8, r9                         ; r8 = total offset = 20 bytes
    mov     eax, dword [rbx + r8]          ; eax = matrix[1][2] = 6

    mov     edi, eax                       ; exit code = 6

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
