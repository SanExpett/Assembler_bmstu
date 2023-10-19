section .data
    a dw 25
    b dw -35
    D db "Алексей", 10
    C db "Alexey", 10
ExitMsg db "Press Enter to exit", 10
lenExit equ $-ExitMsg

section .bss
    x resd 1
    InBuf resb 10
    lenIn equ $-InBuf

section .text

global _start
_start:
    ;write
    mov rax, 1
    mov rdi, 1
    mov rsi, ExitMsg
    mov rdx, lenExit
    syscall
    ;read
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, lenIn
    syscall
    ;exit
    mov rax, 60
    xor rdi, rdi
    syscall