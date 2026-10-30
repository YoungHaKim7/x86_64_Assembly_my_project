; -----------------------------------------------------------------------------
; Project 04 -- string utilities spread over four object files
;
; Demonstrates: one concern per file: strlen.asm, upper.asm, count.asm
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 14.1 (Extern Statement)
;
; Build:  bash build.sh
; Run:    ./proj_04_string_utils
;         -> len=6
;            upper=BANANA
;            count=3        (occurrences of 'a')
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
NL               equ 10

extern strLen
extern strUpper
extern countChar
extern printInt
extern printString

section .data
    lenLabel    db  "len="
    lenLabLen   equ $-lenLabel
    upLabel     db  "upper="
    upLabLen    equ $-upLabel
    cntLabel    db  "count="
    cntLabLen   equ $-cntLabel

section .data
    demoStr     db  "banana", 0

section .bss
    work        resb 32

section .text
global _start
_start:
    ; ---- copy the demo string into writable memory --------------------------
    mov     rsi, demoStr
    mov     rdi, work
.copy:
    lodsb                               ; al = [rsi++]
    stosb                               ; [rdi++] = al
    test    al, al
    jnz     .copy

    ; ---- length --------------------------------------------------------------
    mov     rdi, lenLabel
    mov     rsi, lenLabLen
    call    printString
    mov     rdi, work
    call    strLen
    mov     r12, rax                   ; keep it (syscall clobbers rcx/r11)
    mov     rdi, r12
    call    printInt                   ; "6\n"

    ; ---- uppercased copy ------------------------------------------------------
    mov     rdi, upLabel
    mov     rsi, upLabLen
    call    printString
    mov     rdi, work
    mov     rsi, r12
    call    strUpper                   ; in place
    mov     rdi, work
    mov     rsi, r12
    call    printString                ; "BANANA"
    push    NL
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, rsp
    mov     rdx, 1
    syscall
    add     rsp, 8

    ; ---- character count ------------------------------------------------------
    mov     rdi, cntLabel
    mov     rsi, cntLabLen
    call    printString
    mov     rdi, work
    mov     rsi, r12
    mov     dl, 'A'                    ; uppercase now contains the 'A's
    call    countChar
    mov     rdi, rax
    call    printInt                   ; "3\n"

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
