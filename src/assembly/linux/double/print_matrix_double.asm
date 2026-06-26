; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-26 10:25:04
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 14:51:03
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\double\print_matrix_double.asm
; @Description:  print matrix nasm code on linux
; -------------------------------------------------------------

global print_matrix_double
extern printf
extern puts
extern putchar

section .rodata
    matrix_info    db  "------------------matrix info------------------", 0
    invalid_param  db  "Invalid param!", 0
    matrix_size    db  "matrix size: (%zu, %zu)", 10, 0
    matrix_data    db  "matrix data:", 0
    fmt            db  "%lf ", 0

section .text

; void print_matrix_double(MatrixDouble *m);
; rdi = m (System V)

print_matrix_double:

    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ;  allocate shadow space for printf and puts

    mov r12, rdi                        ; r12 = m

    ; check matrix
    test r12, r12
    jz error

    ; print matrix_info
    lea rdi, [rel matrix_info]          ; rdi = matrix_info
    sub rsp, 8
    call puts wrt ..plt                 ; puts("------------------matrix info------------------\n");
    add rsp, 8

    ; print matrix size
    lea rdi, [rel matrix_size]          ; rdi = matrix_size
    mov rsi, [r12 + 8]                  ; rsi = matrix->rows
    mov rdx, [r12 + 16]                 ; rdx = matrix->cols
    xor eax, eax
    sub rsp, 8
    call printf wrt ..plt               ; printf("matrix size: (%d, %d)\n", matrix->rows, matrix->cols);
    add rsp, 8

    ; print matrix_data
    lea rdi, [rel matrix_data]          ; rdi = matrix_data
    sub rsp, 8
    call puts wrt ..plt                 ; puts("matrix data:"\n);
    add rsp, 8

    ; init loop condition
    xor r13, r13                        ; i = 0
    xor r14, r14                        ; j = 0
    mov r15, [r12]                      ; r15 = matrix->data
    ; mov rdi, [r12 + 8] ; rdi = matrix->rows
    ; mov rsi, [r12 + 16] ; rsi = matrix->cols

loop1:
    cmp r13, [r12 + 8]                  ; i < rdi
    jge end

    xor r14, r14

loop2:
    cmp r14, [r12 + 16]                 ; j < rsi
    jge change_line

    ; print data
    lea rdi, [rel fmt]                  ;
    mov r11, [r12 + 16]                 ; r11 = matrix->cols
    imul r11, r13                       ; r11 *= i
    add r11, r14                        ; now r11 = i * matrix->cols + j
    ; Pay attention to the calling method of printf and parameter passing
    mov rdx, [r15 + r11 * 8]
    movq xmm0, rdx
    sub rsp, 8
    call printf wrt ..plt               ; printf("%lf ", matrix->data[i * matrix->cols + j]);
    add rsp, 8
    inc r14                             ; j++
    jmp loop2

change_line:
    inc r13                             ; i++
    ; print change line
    mov edi, 10
    sub rsp, 8
    call putchar wrt ..plt              ; putchar('\n');
    add rsp, 8
    jmp loop1

error:
    lea rdi, [rel invalid_param]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    jmp end

end:
    add rsp, 32                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    ret
