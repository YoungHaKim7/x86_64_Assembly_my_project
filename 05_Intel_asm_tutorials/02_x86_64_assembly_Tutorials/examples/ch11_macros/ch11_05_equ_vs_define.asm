; -----------------------------------------------------------------------------
; equ constants combined with %define macros
;
; Demonstrates: the difference between an assembler constant (equ) and a
;               preprocessor macro (%define), and how they interoperate
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 11.1 (Single-Line Macros)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch11_05_equ_vs_define.lst ch11_05_equ_vs_define.asm && ld -g -o ch11_05_equ_vs_define ch11_05_equ_vs_define.o
; Run:    ./ch11_05_equ_vs_define ; echo $?        -> exit code: 100
; -----------------------------------------------------------------------------

SYS_exit         equ 60

; equ defines an assembler-level symbolic constant: it is evaluated once at
; assembly time and CANNOT be redefined later in the source.
; (Named ARRAY_SIZE rather than SIZE: yasm reserves the token "SIZE" as a
; keyword, so it cannot be used as an equ label.)
ARRAY_SIZE       equ 25                   ; number of elements in a buffer

; %define defines a preprocessor macro: its body is text that is substituted
; at every use, and it CAN be redefined (the latest definition wins).
%define ELEM_BYTES    4                  ; bytes per element (dword)

; A %define body may reference equ constants: ARRAY_SIZE is resolved by the
; assembler after the textual substitution has taken place.
%define BUFFER_BYTES  (ARRAY_SIZE * ELEM_BYTES)

section .data
    dArr        times ARRAY_SIZE dd 0    ; 25 dwords = 100 bytes of storage

section .text
global _start
_start:

    ; BUFFER_BYTES expands to (ARRAY_SIZE * ELEM_BYTES) -> (25 * 4) -> 100.
    mov     rax, BUFFER_BYTES            ; rax = 100 (total array size)

    ; Cross-check with the assembler's own size-of operator on dArr.
    mov     rbx, dArr                    ; rbx = start of the array
    add     rbx, BUFFER_BYTES            ; rbx = one past the last byte
    sub     rbx, dArr                    ; rbx = 100 bytes, must match rax

    ; The two computations agree only if both equal 100.
    sub     rax, rbx                     ; rax = 0 if rax == rbx == 100
    add     rax, 100                     ; rax = 100

last:
    mov     rdi, rax                     ; exit status = computed result (100)
    mov     rax, SYS_exit                ; call code for exit
    syscall
