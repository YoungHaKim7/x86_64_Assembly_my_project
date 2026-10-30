; -----------------------------------------------------------------------------
; Integer average of {7, 9, 4}: (7+9+4)/3 = 20/3 = 6
;
; Demonstrates: summing a quadword array, then div for the integer average
;               (truncated toward zero)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.5
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_80.lst ch07_80_average.asm && ld -g -o ch07_80 ch07_80_average.o
; Run:    ./ch07_80 ; echo $?        -> exit code: 6
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    qArr        dq 7, 9, 4              ; the values to average
    qLen        dq 3                    ; number of elements

section .bss
    qSum        resq 1                  ; running sum

section .text
global _start
_start:

; --- Pass 1: walk the array and accumulate the sum ------------------------
    mov     rax, 0                      ; rax = sum = 0
    mov     rcx, 0                      ; rcx = index = 0

sumLoop:
    cmp     rcx, qword [qLen]           ; index < length?
    jae     avgPart                     ; no: all elements summed
    add     rax, qword [qArr + rcx*8]   ; sum += qArr[index]
    inc     rcx                         ; next element
    jmp     sumLoop

avgPart:
    mov     qword [qSum], rax           ; sum = 7 + 9 + 4 = 20

; --- Pass 2: integer average = sum / count -------------------------------
    xor     rdx, rdx                    ; clear high dividend half for div
    div     qword [qLen]                ; rax = 20 / 3 = 6, rdx = 2 (ignored)

; Integer division truncates, dropping the .67 -- remainder 2 is in rdx.
    movzx   edi, al                     ; exit status = average (6)

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (6)
