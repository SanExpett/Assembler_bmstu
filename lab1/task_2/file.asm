section .data
    A dword -30
    B dword 21

section .bss
    X resd 1

section .text
    global _start 
_start:
    mov eax, [A]
    add eax, 5
    sub eax, [B]
    mov [X], eax
    syscall

    mov rax, 60
    syscall
