; -----------------------------------------------------------------------------
; Project 02 -- calling a multi-function library from a driver file
;
; Demonstrates: several global functions in one object consumed by another
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 14.1 (Extern Statement)
;
; Build:  bash build.sh
; Run:    ./proj_02_function_library
;         -> min=3
;            max=99
;            abs=47
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

extern minValue
extern maxValue
extern absValue
extern printInt
extern printString

section .data
    minLabel    db  "min="
    minLabLen   equ $-minLabel
    maxLabel    db  "max="
    maxLabLen   equ $-maxLabel
    absLabel    db  "abs="
    absLabLen   equ $-absLabel

section .text
global _start
_start:
    mov     rdi, minLabel
    mov     rsi, minLabLen
    call    printString
    mov     rdi, 3
    mov     rsi, 99
    call    minValue
    mov     rdi, rax
    call    printInt                   ; "3\n"

    mov     rdi, maxLabel
    mov     rsi, maxLabLen
    call    printString
    mov     rdi, 3
    mov     rsi, 99
    call    maxValue
    mov     rdi, rax
    call    printInt                   ; "99\n"

    mov     rdi, absLabel
    mov     rsi, absLabLen
    call    printString
    mov     rdi, -47
    call    absValue
    mov     rdi, rax
    call    printInt                   ; "47\n"

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
