; -----------------------------------------------------------------------------
; stack workspace: sub rsp,32 reserves three qword scratch slots
;
; Demonstrates: manual stack allocation with sub rsp / add rsp, addressing
;               locals as [rsp], [rsp+8], ...
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 9.3 (Stack Local Variables)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch09_06_sub_rsp_workspace.lst ch09_06_sub_rsp_workspace.asm && ld -g -o ch09_06_sub_rsp_workspace ch09_06_sub_rsp_workspace.o
; Run:    ./ch09_06_sub_rsp_workspace ; echo $?        -> exit code: 66
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:

; Reserving scratch space does not need one push per qword: subtracting 32
; from rsp opens four qword slots in one instruction (32 also keeps rsp
; 16-byte aligned, as the ABI expects before any call).
    sub     rsp, 32                        ; reserve 4 qword slots

    mov     qword [rsp], 11                ; slot 0 = 11
    mov     qword [rsp+8], 22              ; slot 1 = 22
    mov     qword [rsp+16], 33             ; slot 2 = 33

    mov     rax, qword [rsp]               ; rax = 11
    add     rax, qword [rsp+8]             ; rax += 22 -> 33
    add     rax, qword [rsp+16]            ; rax += 33 -> 66

    add     rsp, 32                        ; release the workspace

    mov     rdi, rax                       ; exit code = 66

last:
    mov     rax, SYS_exit                  ; call code for exit
    syscall
