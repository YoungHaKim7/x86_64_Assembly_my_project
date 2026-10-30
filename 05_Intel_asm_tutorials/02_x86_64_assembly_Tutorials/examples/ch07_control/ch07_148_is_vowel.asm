; -----------------------------------------------------------------------------
; isVowel -- membership test against a small set
;
; Demonstrates: table-driven classification (scan a set, test for match)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_148.lst ch07_148_is_vowel.asm && ld -g -o ch07_148_is_vowel ch07_148_is_vowel.o
; Run:    ./ch07_148_is_vowel ; echo $?        -> exit code: 1
;
; 'e' is in "aeiou" (1), 't' is not (0); returns the sum.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    vowels      db  "aeiou"            ; membership table
    vLen        equ $-vowels

section .text
global _start

; rdi = char; rax = 1 if found in table else 0
isVowel:
    xor     rax, rax                   ; result = 0
    mov     rsi, vowels                ; rsi -> table
    mov     rcx, vLen                  ; rcx = entries left
.scan:
    cmp     dil, byte [rsi]            ; match?
    je      .found
    inc     rsi
    dec     rcx
    jnz     .scan
    ret
.found:
    mov     rax, 1
    ret

_start:
    xor     r12, r12
    mov     rdi, 'e'
    call    isVowel
    add     r12, rax                   ; +1
    mov     rdi, 't'
    call    isVowel
    add     r12, rax                   ; +0

last:
    mov     rdi, r12                   ; exit status = 1
    mov     rax, SYS_exit
    syscall
