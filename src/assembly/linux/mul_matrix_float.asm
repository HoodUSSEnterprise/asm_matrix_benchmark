;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:41:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-25 14:21:41
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\mul_matrix_float.asm
; @Description: mul matrix float nasm code on linux
;-------------------------------------------------------------

global mul_matrix_float
extern printf
extern malloc
extern free

section .rodata
    malloc_failed db "Memory allocation failed", 10, 0
    invalid_param db "Invalid param!", 10, 0
    dim_mismatch  db "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0

section .text

; MatrixFloat *mul_matrix_float(MatrixFloat *m1, MatrixFloat *m2);
; rdi = m1, rsi = m2 (System V)

mul_matrix_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi
    mov r15, rsi

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

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]
    mov r10, [r15 + 8]
    mov r11, [r15 + 16]

    cmp r9, r10
    jne dimension_mismatch

    mov rdi, r8
    imul rdi, r11

    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov rdi, [r14 + 8]
    imul rdi, [r15 + 16]
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax
    mov r9, [r14 + 8]
    mov r10, [r15 + 16]
    mov [rbx + 8], r9
    mov [rbx + 16], r10

    xor rdi, rdi
    xor rsi, rsi
    xor r13, r13
    mov rdx, [r14 + 16]
    mov rcx, [r15 + 16]
    mov r11, [rbx]

    mov r14, [r14]
    mov r15, [r15]

loop1:
    cmp rdi, r9
    jge end
    xor rsi, rsi
    loop2:
        cmp rsi, r10
        jge inc_rdi
        xorps xmm0, xmm0
        xor r13, r13
        loop3:
            cmp r13, rdx
            jge give_value

            mov r8, rdi
            imul r8, rdx
            add r8, r13
            movss xmm1, [r14 + r8 * 4]

            mov r8, r13
            imul r8, rcx
            add r8, rsi
            mulss xmm1, [r15 + r8 * 4]

            addss xmm0, xmm1
            inc r13
            jmp loop3

    give_value:
        mov r8, rdi
        imul r8, r10
        add r8, rsi
        movss [r11 + r8 * 4], xmm0
        inc rsi
        jmp loop2

inc_rdi:
    inc rdi
    jmp loop1

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

end:
    mov rax, rbx

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
