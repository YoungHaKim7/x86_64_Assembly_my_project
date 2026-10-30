; -----------------------------------------------------------------------------
; Project 03 -- extern/global vs file-local (static) symbols
;
; Demonstrates: what the linker can and cannot see across object files
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 14.1 (Extern Statement)
;
; Build:  bash build.sh
; Run:    ./proj_03_extern_global ; echo $?        -> exit code: 0
;
; main.asm externs globalRoutine only.  fileLocal in helper.asm is invisible
; here; if you added 'extern fileLocal' the link would fail with
; "undefined symbol" -- assembly-time labels are private unless exported.
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

extern globalRoutine

section .text
global _start
_start:
    call    globalRoutine              ; rax = 101
    sub     rax, 101                   ; zero when everything linked right

last:
    mov     rdi, rax                    ; exit status = 0
    mov     rax, SYS_exit
    syscall
