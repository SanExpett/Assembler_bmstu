section .bss
    alu resw 10
    f1 resb 5
section .data
    vall db 255
    chart dw 256
    lue3 dw -128
    v5 db 10h
    db 100101b
    beta db 23, 23h, 0ch
    sdk db "Hello", 10
    min dw -32767
    ar dd 12345678h
    valar times 5 db 8
section .text
    global _start
_start:
    mov eax, 60
    syscall