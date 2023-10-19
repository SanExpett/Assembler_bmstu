%include "./lib64.asm"

section .data
    ResMsg db "Answer is: f = "
    lenRes equ $-ResMsg

    AMsg db "Enter a = "
    lenAMsg equ $-AMsg

    BMsg db "Enter b = "
    lenBMsg equ $-BMsg

    StartMsg db "Computed expression",0x0A," if a*b>0 then f=(a+b)/(a-b) else f = -120/(a*b)",0x0A
    lenStart equ $-StartMsg

    ZeroDiv db "Zero division is forbidden", 0xa
    lenZeroDiv equ $-ZeroDiv

    ExitMsg db "Exiting...",   0xa
    lenExit equ $-ExitMsg

section .bss
    InBuf resd 1
    OutBuf resq 1
    lenIn equ $-InBuf
    lenOut equ $-OutBuf
    A resd 1
    B resd 1
    F resd 1

section .text
global _start
_start:
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, StartMsg ; адрес выводимой строки
    mov rdx, lenStart ; длина строки
    syscall; вызов системной функции
    ; write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, AMsg ; адрес выводимой строки
    mov rdx, lenAMsg ; длина строки
    syscall; вызов системной функции
    ; read
    mov rax, 0 
    mov rdi, 0 
    mov rsi, InBuf 
    mov rdx, lenIn 
    syscall

    mov rdi, InBuf
    call StrToInt64
    cmp rbx, 0
    jne 0
    mov [A], rax
    ;write
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, BMsg ; адрес выводимой строки
    mov rdx, lenBMsg ; длина строки
    syscall; вызов системной функции
    ; read
    mov rax, 0 
    mov rdi, 0 
    mov rsi, InBuf 
    mov rdx, lenIn 
    syscall
    mov rdi, InBuf
    call StrToInt64
    cmp rbx, 0
    jne 0
    mov [B], rax

    ;CALCULATIONS 
    mov eax, [A]
    mov ebx, [B]
    imul eax, ebx
    cmp eax, 0
    je zero_division
    jg else
    
    mov ebx, eax
    mov eax, -120
    cdq
    idiv ebx
    mov [F], eax
    jmp continue



    zero_division:
    ; write
    mov ax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ZeroDiv ; адрес выводимой строки
    mov rdx, lenZeroDiv ; длина строки
    syscall
    jmp exit

    else:
    mov ebx, [B]
    cmp ebx, [A]
    je zero_division
    mov eax, [A]
    add eax, [B]
    mov ecx, [A]
    sub ecx, [B]
    cdq
    idiv ecx
    mov [F], eax

    continue:
    ;ouput
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ResMsg ; адрес выводимой строки
    mov rdx, lenRes ; длина строки
    syscall; вызов системной функции
    mov rsi, OutBuf; Pass address of output buffer to IntToStr64
    mov rax, [F]
    call IntToStr64
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, OutBuf ; адрес выводимой строки
    mov rdx, lenOut ; длина строки
    syscall; вызов системной функции
    
    exit:
    mov rax, 1; системная функция 1 (write)
    mov rdi, 1; дескриптор файла stdout=1
    mov rsi, ExitMsg; адрес выводимой строки
    mov rdx, lenExit ; длина строки
    syscall; вызов системной функции
    mov rax, 60; системная функция 60 (exit)
    xor rdi, rdi; return code 0
    syscall; вызов системной функции
