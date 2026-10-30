; -----------------------------------------------------------------------------
; loope/loopz: scan an array while elements keep matching (ZF = 1)
;
; Demonstrates: loope — loop while rcx != 0 AND ZF = 1; test reg,reg
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_129.lst ch07_129_loope_scan.asm && ld -g -o ch07_129 ch07_129_loope_scan.o
; Run:    ./ch07_129 ; echo $?       -> exit code: 2
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd 0, 0, 7              ; scan walks over the zeros, stops at 7

section .text
global _start
_start:

; loope (alias loopz) decrements rcx and jumps only when rcx != 0 AND
; ZF = 1 — the loop body must therefore END with the instruction that
; sets ZF.  Here `test eax,eax` sets ZF = 1 exactly for zero elements,
; so the scan repeats over the leading zeros and falls out at the first
; NON-zero element (index 2).  Note the pointer is advanced BEFORE the
; test: add changes the flags, and the flags in force when loope executes
; are the ones it reads.
    mov     rcx, 3                  ; element count: hard bound on the scan
    mov     rdi, dArr               ; rdi -> first element (a pointer)
scanLoop:
    mov     eax, dword [rdi]        ; eax = current element
    add     rdi, 4                  ; advance pointer first (add sets flags)
    test    eax, eax                ; element == 0?  -> ZF = 1
    loope   scanLoop                ; rcx--; repeat while rcx != 0 and ZF = 1

; The scan stopped on the element just before rdi; convert that address
; back into an element index.
    mov     rbx, rdi
    sub     rbx, dArr               ; byte offset just past the stopping spot
    sub     rbx, 4                  ; back up to the element itself
    shr     rbx, 2                  ; / 4 bytes per dword -> index 2

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = index of first non-zero
    syscall
