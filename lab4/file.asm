%include "lib64.asm"
section .data ; сегмент инициализированных переменных
    EntrMsg db "Enter element: ",10 ; выводимое сообщение
    lenEntr equ $-EntrMsg  
    ExitMsg db "Answer:",10 ; выводимое сообщение
    lenExit equ $-ExitMsg
    len_arr dd 25 ; длина массива
section .bss ; сегмент неинициализированных переменных
    InBuf   resb    10 ; буфер для вводимой строки
    lenIn   equ     $-InBuf
    OutBuf  resb    10 ; буфер для вводимой строки
    arr resw 25
section .text 
    global _start
_start:
    mov r8, 0 ; инициализация счетчика элементов
    mov ecx, [len_arr] ; загрузка счетчика
begin_loop_input:  ;ввод массива
    push rcx
    mov rsi, EntrMsg ; адрес выводимой строки
    mov rdx, lenEntr ; длина строки
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    syscall ; вызов системной функции
    mov rsi, InBuf ; адрес вводимой строки
    mov rdx, lenIn ; длина строки
    mov rax, 0 ; системная функция 0 (read)
    mov rdi, 0 ; дескриптор файла stdin=0
    syscall ; вызов системной функции
    mov esi, InBuf ; адрес введенной строки
    call StrToInt64
    cmp ebx, 0 ; проверка кода ошибки
    jne  StrToInt64.Error ; при преобразовании обнаружена ошибка
    mov [r8*2+arr], eax ; запись числа в память
    pop rcx
    inc r8 ; инкрементирование счетчика элементов
    loop begin_loop_input
    
    mov r8, 0 ; инициализация счетчика элементов
    mov ecx, [len_arr] ; загрузка счетчика
    sub ecx, 1
    mov dx, 1 ; количество уникальных элементов
begin_loop_count:
    mov r10, 0 ; количество повторений конкретного элемента
    push rcx
    mov ax, [r8*2+arr] ; загрузка числа в регистр
    mov r9, 0 ; инициализация внутреннего счетчика элементов
begin_loop_inner:
    lea r11, [r8*2]
    lea r12, [r9*2]
    add r11,r12 ; вычисление адреса
    mov bx, [r11+arr+2] ; загрузка числа в регистр
    inc r9 ; инкрементирование внутреннего счетчика элементов
    cmp bx, ax 
    je count
    jmp else_inner
count:
    add r10, 1 ; подсчет количества повторений конкретного элемента
else_inner:
    loop begin_loop_inner  
    pop rcx
    inc r8 ; инкрементирование счетчика элементов
    cmp r10, 0
    je increm
    jmp else_outer
increm:
    add dx, 1 ; подсчет уникальных элементов
else_outer:
    loop begin_loop_count
    mov [arr], dx ; запись числа элементов на 0 элемент
   
    mov rsi, ExitMsg ; адрес выводимой строки
    mov rdx, lenExit ; длина строки
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    syscall ; вызов системной функции
    mov r8, 0 ; инициализация счетчика элементов
    mov ecx, [len_arr] ; загрузка счетчика
begin_loop_output:
    push rcx
    mov esi, OutBuf ; загрузка адреса буфера вывода
    mov eax, [r8*2+arr] ; загрузка числа в регистр
    cwde ; развертывание числа из ax в eax
    call IntToStr64
    mov rsi, OutBuf ; адрес выводимой строки
    mov rdx, rax ; длина строки
    mov rax, 1 ; системная функция 1 (write)
    mov rdi, 1 ; дескриптор файла stdout=1
    syscall ; вызов системной функции
    pop rcx 
    inc r8 ; инкрементирование счетчика элементов
    loop begin_loop_output
    
    mov rsi, InBuf ; адрес вводимой строки
    mov rdx, lenIn ; длина строки
    mov rax, 0 ; системная функция 0 (read)
    mov rdi, 0 ; дескриптор файла stdin=0
    syscall ; вызов системной функции
    mov rax, 60 ; системная функция 60 (exit)
    xor rdi, rdi ; return code 0
    syscall ; вызов системной функции
