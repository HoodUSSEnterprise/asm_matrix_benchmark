;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-20 16:10:25
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-20 16:16:08
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\print_matrix_int.asm
; @Description: print matrix nasm code on linux
;-------------------------------------------------------------

global print_matrix
extern printf
extern puts
extern putchar

section .rodata
    matrix_info db "------------------matrix info------------------", 0
    invalid_param db "Invalid param!", 0                                   ; invalid param msg
    matrix_size db "matrix size: (%d, %d)", 10, 0
    matrix_data db "matrix data:", 0
    fmt db "%d ", 0

section .text

; void print_matrix(MatrixInt *m);
; rcx = m
print_matrix:
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32 ;  allocate shadow space for printf and puts

    mov r12, rcx ; r12 = m

    ; check matrix
    test r12, r12
    jz error

    ; print matrix_info
    lea rcx, [rel matrix_info] ; rcx = matrix_info
    call puts ; puts("------------------matrix info------------------\n");

    ; print matrix size
    lea rcx, [rel matrix_size] ; rcx = matrix_size
    mov rdx, [r12 + 8] ; rdx = matrix->rows
    mov r8, [r12 + 16] ; r8 = matrix->cols
    call printf ; printf("matrix size: (%d, %d)\n", matrix->rows, matrix->cols);

    ; print matrix_data
    lea rcx, [rel matrix_data] ; rcx = matrix_data
    call puts ; puts("matrix data:"\n);

    ; init loop condition
    xor r13, r13 ; i = 0
    xor r14, r14 ; j = 0
    mov r15, [r12] ; r15 = matrix->data
    mov rdi, [r12 + 8] ; rdi = matrix->rows
    mov rsi, [r12 + 16] ; rsi = matrix->cols

loop1:
    cmp r13, rdi ; i < rdi
    jge end

    xor r14, r14
loop2:
    cmp r14, rsi ; j < rsi
    jge change_line

    ; print data
    lea rcx, [rel fmt] ;
    mov r11, rsi ; r11 = matrix->cols
    imul r11, r13 ; r11 *= i
    add r11, r14  ; now r11 = i * matrix->cols + j
    mov rdx, [r15 + r11 * 4]
    call printf ; printf("%d ", matrix->data[i * matrix->cols + j]);
    inc r14; j++
    jmp loop2

change_line:
    inc r13 ; i++
    ; print change line
    mov rcx, 10
    call putchar ; putchar('\n');
    jmp loop1

error:
    lea rcx, [rel invalid_param]
    call puts
    jmp end

end:
    add rsp, 32 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    ret
