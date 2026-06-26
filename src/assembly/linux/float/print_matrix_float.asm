; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:46:01
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:17:43
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\float\print_matrix_float.asm
; @Description: print matrix float nasm code on linux
; -------------------------------------------------------------

global print_matrix_float
extern printf
extern puts
extern putchar

section .rodata
    matrix_info    db  "------------------matrix info------------------", 0
    invalid_param  db  "Invalid param!", 0
    matrix_size    db  "matrix size: (%d, %d)", 10, 0
    matrix_data    db  "matrix data:", 0
    fmt            db  "%f ", 0

section .text

; void print_matrix_float(MatrixFloat *m);
; rdi = m (System V)

print_matrix_float:
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r12, rdi

    test r12, r12
    jz error

    lea rdi, [rel matrix_info]
    call puts wrt ..plt

    lea rdi, [rel matrix_size]
    mov rsi, [r12 + 8]
    mov rdx, [r12 + 16]
    xor eax, eax
    call printf wrt ..plt

    lea rdi, [rel matrix_data]
    call puts wrt ..plt

    xor r13, r13
    xor r14, r14
    mov r15, [r12]
    mov rbx, [r12 + 8]

loop1:
    cmp r13, rbx
    jge end

    xor r14, r14

loop2:
    mov rsi, [r12 + 16]
    cmp r14, rsi
    jge change_line

    lea rdi, [rel fmt]
    mov r11, rsi
    imul r11, r13
    add r11, r14
    movss xmm0, [r15 + r11 * 4]
    cvtss2sd xmm0, xmm0
    mov al, 1
    call printf wrt ..plt
    inc r14
    jmp loop2

change_line:
    inc r13
    mov edi, 10
    call putchar wrt ..plt
    jmp loop1

error:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    jmp end

end:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
