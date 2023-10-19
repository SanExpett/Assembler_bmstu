%include "lib64.asm"
section .data
    StartMsg db 10, "Enter your numbers...", 10
    StartLen equ $-StartMsg

    ExitMsg db 10, "Your result", 10
    ExitLen equ $-ExitMsg

    error db "Zero divizion", 10

section .bss
    a resd 1
    b resd 1
    x resd 1
    d resd 1

    InBuf resb 10
    OutBuf resb 4
    LenIn equ $-InBuf
    LenOut equ $-OutBuf

section .text
    global _start
_start:
    ;вывод начального сообщения
    mov rax, 1
    mov rdi, 1
    mov rsi, StartMsg
    mov rdx, StartLen
    syscall

    ;ввод переменных
    ;a
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, LenIn
    syscall

    mov rdi, InBuf
    call StrToInt64
    cmp rbx, 0
    jne 0
    mov [a], eax

    ;b
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, LenIn
    syscall

    mov rdi, InBuf
    call StrToInt64
    cmp rbx, 0
    jne 0
    mov [b], rax

    mov rax, [b]
    cmp rax, 5
    je input_error

    ;x
    mov rax, 0
    mov rdi, 0
    mov rsi, InBuf
    mov rdx, LenIn
    syscall

    mov rdi, InBuf
    call StrToInt64
    cmp rbx, 0
    jne 0
    mov [x], rax

    ;вычисления

    ;числитель
    mov eax, 3  
    imul dword[a]
    imul dword[x]

    mov ebx, [b]
    sub ebx, 5
    imul ebx, 5
    cqd
    idiv ebx ;ответ

    mov [d], eax ;кладем результат в нужную переменную

    ;вывод
    mov rax, 1
    mov rdi, 1
    mov rsi, ExitMsg
    mov rdx, ExitLen
    syscall

    mov rsi, OutBuf
    mov rax, [d]
    call IntToStr64

    mov rax, 1
    mov rdi, 1
    mov rsi, OutBuf
    mov rdx, LenOut
    syscall

    ;выход
    mov rax, 60
    xor rdi, rdi
    syscall    

input_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, error
    mov edx, 43
    int 0x80
    jmp _start