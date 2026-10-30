; -----------------------------------------------------------------------------
; Minimum and maximum in one pass (two return values)
;
; Demonstrates: returning a pair of results -- minimum in rax, maximum in
;               rdx -- from a single scan of the array
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 12.8.2 (Register Usage)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch12_30_min_max_function.lst ch12_30_min_max_function.asm && ld -g -o ch12_30_min_max_function ch12_30_min_max_function.o
; Run:    ./ch12_30_min_max_function ; echo $?        -> exit code: 21
; -----------------------------------------------------------------------------

SYS_exit         equ 60

section .data
    qArr        dq 4, 17, 9             ; min = 4, max = 17
    qLen        dq 3

section .text
global _start

; -----------------------------------------------------------------------------
; minMax -- rdi = array address, rsi = length (>= 1); returns the minimum
;           element in rax and the maximum in rdx.
;
; rax and rdx double as the best-so-far registers, so the final values are
; already in the conventional return slots when ret executes.
minMax:
    mov     rax, qword [rdi]            ; min = arr[0]
    mov     rdx, rax                    ; max = arr[0]
.next:
    dec     rsi                         ; one element already consumed
    jz      .done
    add     rdi, 8                      ; advance to the next quadword
    mov     rcx, qword [rdi]            ; rcx = candidate
    cmp     rcx, rax
    jge     .tryMax
    mov     rax, rcx                    ; new minimum
    jmp     .next
.tryMax:
    cmp     rcx, rdx
    jle     .next
    mov     rdx, rcx                    ; new maximum
    jmp     .next
.done:
    ret

_start:
    mov     rdi, qArr                   ; argument 1: array address
    mov     rsi, qword [qLen]           ; argument 2: element count
    call    minMax                      ; rax = 4 (min), rdx = 17 (max)

    add     rax, rdx                    ; rax = 4 + 17 = 21 (both verified)

last:
    mov     rdi, rax                    ; exit status = 21
    mov     rax, SYS_exit               ; call code for exit
    syscall
