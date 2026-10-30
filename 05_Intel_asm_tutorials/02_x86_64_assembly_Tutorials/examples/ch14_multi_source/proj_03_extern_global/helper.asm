; -----------------------------------------------------------------------------
; helper.asm -- symbol visibility: one global, one file-local label
;
; globalRoutine is exported: main.asm can call it through the linker.
; fileLocal is NOT exported: only code inside this file can reach it.
; (Calling fileLocal from main.asm would be a link error -- try it!)
; -----------------------------------------------------------------------------

section .text
global globalRoutine

globalRoutine:
    call    fileLocal                  ; reachable: same file
    add     rax, 100                   ; 1 + 100 = 101
    ret

fileLocal:                             ; no 'global' -> stays private
    mov     rax, 1
    ret
