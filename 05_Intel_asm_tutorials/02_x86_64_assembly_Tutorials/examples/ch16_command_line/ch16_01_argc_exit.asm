; -----------------------------------------------------------------------------
; argc -- the argument count from the initial process stack
;
; Demonstrates: _start stack layout: [rsp] = argc
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 16.3 (Argument Count and Vector Table)
;
; Build:  yasm -f elf64 -g dwarf2 -l ch16_01.lst ch16_01_argc_exit.asm && ld -g -o ch16_01_argc_exit ch16_01_argc_exit.o
; Run:    ./ch16_01_argc_exit x y z ; echo $?        -> exit code: 4
;
; Linux builds this stack right above _start:
;   [rsp]     argc        (program name counts as the first "argument")
;   [rsp+8]   argv[0]     -> program path string
;   [rsp+16]  argv[1] ... argv[argc-1], then NULL
;   ...       envp array, then NULL
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .text
global _start
_start:
    mov     rdi, qword [rsp]           ; argc sits at the top of the stack

last:
    mov     rax, SYS_exit
    syscall                             ; exit status = argc
