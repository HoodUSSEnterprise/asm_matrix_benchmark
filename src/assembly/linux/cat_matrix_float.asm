;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\cat_matrix_float.asm
; @Description: cat matrix float nasm code on linux
;-------------------------------------------------------------
global cat_matrix_float
extern malloc
extern free
extern printf
extern puts

section .rodata
    malloc_failed db "Memory allocation failed", 10, 0
    invalid_param db "Invalid param!", 10, 0
    dim_mismatch  db "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0
    wrong_params  db "Wrong value, axis must be 0 or 1"

section .text

; MatrixFloat *cat_matrix_float(MatrixFloat *m1, MatrixFloat *m2, int axis);
; rdi = m1, rsi = m2, edx = axis (System V)
; axis : 1 means horizon, 0 means vertical
cat_matrix_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi
    mov r15, rsi
    mov r13d, edx

    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    mov r14, [rdi]
    mov r15, [rsi]

    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    mov r14, rdi
    mov r15, rsi

    cmp r13d, 0
    jne greater_than_zero

    mov r9, [r14 + 16]
    mov r11, [r15 + 16]

    cmp r9, r11
    jne dimension_mismatch

    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov rcx, [r14 + 16]
    mov r12, [r14 + 8]
    add r12, [r15 + 8]
    imul rcx, r12
    mov rdi, rcx
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax
    mov [rbx + 8], r12
    mov r8, [r14 + 16]
    mov [rbx + 16], r8

    xor rcx, rcx
    xor rdx, rdx
    mov rdi, [r14 + 16]
    mov rsi, [rbx]
    mov r8, [r14 + 8]
    mov r14, [r14]
    mov r15, [r15]

loop1:
    cmp rcx, r12
    jge end
    xor rdx, rdx

    loop2:
        cmp rdx, rdi
        jge loop1out1

        cmp rcx, r8
        jge matrix_after1
        mov r9, rdi
        imul r9, rcx
        add r9, rdx
        movss xmm0, [r14 + r9 * 4]
        movss [rsi + r9 * 4], xmm0
        inc rdx
        jmp loop2

    matrix_after1:
        mov r13, rdi
        imul r13, rcx
        add r13, rdx
        mov r9, rdi
        mov r11, rcx
        sub r11, r8
        imul r9, r11
        add r9, rdx
        movss xmm0, [r15 + r9 * 4]
        movss [rsi + r13 * 4], xmm0
        inc rdx
        jmp loop2

loop1out1:
    inc rcx
    jmp loop1

greater_than_zero:
    cmp r13, 1
    jne invalid_axis

    mov r9, [r14 + 8]
    mov r11, [r15 + 8]

    cmp r9, r11
    jne dimension_mismatch

    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov rdi, [r14 + 8]
    mov r12, [r14 + 16]
    add r12, [r15 + 16]
    imul rdi, r12
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax
    mov r8, [r14 + 8]
    mov [rbx + 8], r8
    mov [rbx + 16], r12

    xor rcx, rcx
    xor rdx, rdx
    mov rdi, [r14 + 16]
    mov r13, [r15 + 16]
    mov rsi, [rbx]
    mov r14, [r14]
    mov r15, [r15]

loop11:
    cmp rcx, r8
    jge end
    xor rdx, rdx

    loop21:
        cmp rdx, r12
        jge loop1out11

        cmp rdx, rdi
        jge matrix_after11
        mov r9, rdi
        imul r9, rcx
        add r9, rdx
        movss xmm0, [r14 + r9 * 4]
        mov r9, r12
        imul r9, rcx
        add r9, rdx
        movss [rsi + r9 * 4], xmm0
        inc rdx
        jmp loop21

    matrix_after11:
        mov r9, r13
        imul r9, rcx
        add r9, rdx
        sub r9, rdi
        movss xmm0, [r15 + r9 * 4]
        mov r9, r12
        imul r9, rcx
        add r9, rdx
        movss [rsi + r9 * 4], xmm0
        inc rdx
        jmp loop21

loop1out11:
    inc rcx
    jmp loop11

invalid_axis:
    lea rdi, [rel wrong_params]
    call puts wrt ..plt
    jmp cleanup

malloc_fail_struct:
    lea rdi, [rel malloc_failed]
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rdi, [rel malloc_failed]
    xor eax, eax
    call printf wrt ..plt
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0
    jmp cleanup

end:
    mov rax, rbx
    jmp cleanup

dimension_mismatch:
    lea rdi, [rel dim_mismatch]
    mov rsi, [r14 + 8]
    mov rdx, [r14 + 16]
    mov rcx, [r15 + 8]
    mov r8, [r15 + 16]
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0
    jmp cleanup

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
