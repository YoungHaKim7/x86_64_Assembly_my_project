; -----------------------------------------------------------------------------
; Reference example: console-output style (SYS_write + itoa)
;
; Demonstrates: SYS_write syscall, string output, integer-to-ASCII (itoa)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, sections 13.3 (Console Output) and 13.8
;
; Build:  yasm -f elf64 -g dwarf2 -l chR_03.lst chR_03_output_style.asm && ld -g -o chR_03 chR_03_output_style.o
; Run:    ./chR_03                     -> prints: 12345
; -----------------------------------------------------------------------------
; Output verification: stdout is exactly "value = 12345\n".
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
NULL             equ 0
TRUE             equ 1
FALSE            equ 0
NL               equ 10

section .data
    msg         db  "value = "
    msgLen      equ $-msg

section .bss
    tmpBuffer   resb 32                ; scratch for itoa digits

section .text
global _start

; -----------------------------------------------------------------------------
; printString -- rdi = address, rsi = length; writes to STDOUT
printString:
    mov     rdx, rsi                   ; arg 3: count
    mov     rsi, rdi                   ; arg 2: buffer address
    mov     rax, SYS_write             ; arg 1: fd already in rdx? no:
    mov     rdi, STDOUT                ; arg 1: file descriptor = STDOUT
    syscall
    ret

; -----------------------------------------------------------------------------
; itoa -- rdi = value (treated as signed), rsi = buffer address
;         returns length in rax; appends trailing newline
itoa:
    mov     rax, rdi                   ; rax = value to convert
    mov     r8, rsi                    ; r8 = buffer pointer
    mov     r9, 0                      ; r9 = digit count
    mov     r10, TRUE                  ; negative flag
    test    rax, rax                   ; negative?
    jns     .notNeg
    neg     rax                        ; work with absolute value
    jmp     .divLoop
.notNeg:
    mov     r10, FALSE
.divLoop:
    mov     rbx, 10                    ; divisor
    xor     rdx, rdx                   ; rdx:rax = dividend (zero-extend)
    div     rbx                        ; rax = quotient, rdx = digit
    add     dl, "0"                    ; convert digit to ASCII
    push    rdx                        ; save digit (reverse order)
    inc     r9
    cmp     rax, 0
    jne     .divLoop

    cmp     r10, TRUE                  ; prepend '-' if negative
    jne     .noSign
    mov     byte [r8], '-'
    inc     r8
    inc     r9
.noSign:
.popLoop:
    pop     rdx                        ; digits pop in correct order
    mov     byte [r8], dl
    inc     r8
    dec     r9
    cmp     r9, 0
    jg      .popLoop

    mov     byte [r8], NL              ; newline terminator (also counted)
    mov     rax, r8
    sub     rax, rsi                   ; rax = total length incl. newline
    ret

; -----------------------------------------------------------------------------
_start:
    mov     rdi, msg                   ; print the label first
    mov     rsi, msgLen
    call    printString

    mov     rdi, 12345                 ; convert this value
    mov     rsi, tmpBuffer
    call    itoa                       ; rax = string length

    mov     rdi, tmpBuffer             ; print the number + newline
    mov     rsi, rax
    call    printString

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
