section .data
    dw 25h
    dw 2500h
    dw 37
    dw 9472
section .bss

section .text
    global _start
_start:
    mov rax, 60
    syscall