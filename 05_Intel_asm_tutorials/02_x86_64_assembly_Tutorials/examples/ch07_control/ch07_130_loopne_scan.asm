; -----------------------------------------------------------------------------
; loopne/loopnz: scan an array while elements keep NOT matching (ZF = 0)
;
; Demonstrates: loopne — loop while rcx != 0 AND ZF = 0; classic key search
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.7 (Control Instructions)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_130.lst ch07_130_loopne_scan.asm && ld -g -o ch07_130 ch07_130_loopne_scan.o
; Run:    ./ch07_130 ; echo $?       -> exit code: 2
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
    dArr        dd 5, 3, 0, 9           ; scan walks over the non-zeros, stops at 0

section .text
global _start
_start:

; loopne (alias loopnz) is the mirror of loope: it decrements rcx and jumps
; only when rcx != 0 AND ZF = 0.  With `test eax,eax` setting ZF = 0 for
; every NON-zero element, the scan skips 5 and 3 and falls out exactly at
; the first ZERO — the classic "search until the key matches" shape.
; The pointer advances before the test because add changes the flags.
    mov     rcx, 3                  ; element count: hard bound on the scan
    mov     rdi, dArr               ; rdi -> first element (a pointer)
scanLoop:
    mov     eax, dword [rdi]        ; eax = current element
    add     rdi, 4                  ; advance pointer first (add sets flags)
    test    eax, eax                ; element != 0?  -> ZF = 0
    loopne  scanLoop                ; rcx--; repeat while rcx != 0 and ZF = 0

; The scan stopped on the element just before rdi; convert that address
; back into an element index.
    mov     rbx, rdi
    sub     rbx, dArr               ; byte offset just past the stopping spot
    sub     rbx, 4                  ; back up to the element itself
    shr     rbx, 2                  ; / 4 bytes per dword -> index 2

last:
    mov     rax, SYS_exit           ; call code for exit
    mov     rdi, rbx                ; exit status = index of first zero
    syscall
