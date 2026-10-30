; -----------------------------------------------------------------------------
; Line buffering -- flush only when a newline lands
;
; Demonstrates: the terminal-style buffering discipline
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 17.2 (Buffering Algorithm)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch17_03.lst ch17_03_line_buffered.asm && ld -g -o ch17_03_line_buffered ch17_03_line_buffered.o
; Run:    ./ch17_03_line_buffered
;         -> one
;            two           (exactly two flushes, one per line)
;
; appendChar inspects the byte: a newline triggers flushBuffer immediately;
; other characters just accumulate.  Same visible output as unbuffered
; writes, with far fewer syscalls.
; -----------------------------------------------------------------------------

SYS_write        equ 1
SYS_exit         equ 60
EXIT_SUCCESS     equ 0
STDOUT           equ 1
NL               equ 10

section .data
    lineOne      db  "one"
    lineTwo      db  "two"

section .bss
    outBuf      resb 64
    fillCount   resq 1
    flushCount  resq 1                  ; how many syscalls we made

section .text
global _start

; ---- write out everything buffered and reset the count ----------------------
flushBuffer:
    cmp     qword [fillCount], 0        ; nothing buffered? nothing to do
    je      .done
    mov     rax, SYS_write
    mov     rdi, STDOUT
    mov     rsi, outBuf
    mov     rdx, qword [fillCount]
    syscall
    mov     qword [fillCount], 0
    inc     qword [flushCount]
.done:
    ret

; ---- append one character from al, flushing on newline ----------------------
appendChar:
    mov     rdx, qword [fillCount]
    mov     byte [outBuf + rdx], al
    inc     qword [fillCount]
    cmp     al, NL
    jne     .done
    call    flushBuffer                 ; newline -> emit the whole line
.done:
    ret

_start:
    mov     rsi, lineOne
    mov     rcx, 3
.oneLoop:                               ; "one" + NL
    mov     al, byte [rsi]
    call    appendChar
    inc     rsi
    dec     rcx
    jnz     .oneLoop
    mov     al, NL
    call    appendChar                  ; flush #1

    mov     rsi, lineTwo
    mov     rcx, 3
.twoLoop:                               ; "two" + NL
    mov     al, byte [rsi]
    call    appendChar
    inc     rsi
    dec     rcx
    jnz     .twoLoop
    mov     al, NL
    call    appendChar                  ; flush #2

last:
    mov     rax, SYS_exit
    mov     rdi, EXIT_SUCCESS
    syscall
