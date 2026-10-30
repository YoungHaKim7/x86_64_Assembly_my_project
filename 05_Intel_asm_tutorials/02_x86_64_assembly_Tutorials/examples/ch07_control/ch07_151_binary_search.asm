; -----------------------------------------------------------------------------
; Binary search -- halving an ordered array until the key is found
;
; Demonstrates: while-loop with signed comparisons over array indexes
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_151.lst ch07_151_binary_search.asm && ld -g -o ch07_151_binary_search ch07_151_binary_search.o
; Run:    ./ch07_151_binary_search ; echo $?        -> exit code: 3
;
; Searching for 23 in {3,9,14,23,37,58}: mid settles on index 3 after
; three probes.  Signed jumps (jl/jg) matter: indexes are signed counts.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd  3, 9, 14, 23, 37, 58
    dLen        equ ($-dArr)/4         ; 6 elements

section .text
global _start
_start:
    mov     eax, 23                    ; key to find
    xor     r8, r8                     ; low  = 0
    mov     r9, dLen-1                 ; high = 5
    mov     r10, -1                    ; result index if not found

.searchLoop:
    cmp     r8, r9                     ; low > high -> absent
    jg      .done

    mov     rbx, r8
    add     rbx, r9
    shr     rbx, 1                     ; mid = (low+high)/2

    movsxd  rcx, dword [dArr + rbx*4]  ; value at mid
    cmp     rcx, rax
    je      .found
    jl      .goRight                   ; value < key -> search upper half
    mov     r9, rbx
    dec     r9                         ; high = mid-1
    jmp     .searchLoop
.goRight:
    mov     r8, rbx
    inc     r8                         ; low = mid+1
    jmp     .searchLoop

.found:
    mov     r10, rbx                   ; index of the key
.done:
    mov     rax, r10                   ; 3 (or -1 -> 255 if absent)

last:
    mov     rdi, rax                   ; exit status = 3
    mov     rax, SYS_exit
    syscall
