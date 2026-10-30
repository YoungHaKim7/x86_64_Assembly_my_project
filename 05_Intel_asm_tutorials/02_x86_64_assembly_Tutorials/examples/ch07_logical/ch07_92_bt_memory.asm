; -----------------------------------------------------------------------------
; BT on memory: bit 70 of a bit string in memory -> CF=1
;
; Demonstrates: bt with a memory bit base indexing a long bit string that
;               spans several qwords (the jump-table idiom)
; Book ref:     "x86-64 Assembly Language Programming with Ubuntu",
;               Ed Jorgensen, section 7.6
;
; Build:  yasm -f elf64 -g dwarf2 -l ch07_92.lst ch07_92_bt_memory.asm && ld -g -o ch07_92 ch07_92_bt_memory.o
; Run:    ./ch07_92 ; echo $?        -> exit code: 1
; -----------------------------------------------------------------------------

SYS_exit         equ 60
EXIT_SUCCESS     equ 0

section .data
; A 128-bit bit string: qArr[0] holds bits 0..63, qArr[1] bits 64..127.
    qArr        dq 0                    ; bits  0..63  all clear
                dq 0x40                 ; bits 64..127: only bit 6 set

section .text
global _start
_start:

; With a register bit offset BT treats memory as the start of a bit
; string of unlimited length: bit 70 lies 64+6 bits in, i.e. bit 6 of
; the SECOND qword (0x40), so CF becomes 1.
    mov     rcx, 70                     ; bit number to test
    mov     edi, 0                      ; assume the bit is clear
    bt      qword [qArr], rcx           ; CF = bit 70 = bit 6 of qArr[1] = 1
    jnc     last                        ; not taken (CF = 1)
    mov     edi, 1                      ; CF was set: bit 70 is 1

last:
    mov     rax, SYS_exit               ; call code for exit
    syscall                             ; status in rdi (1)
