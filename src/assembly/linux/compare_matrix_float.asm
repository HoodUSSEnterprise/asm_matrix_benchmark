;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:38:22
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:41:05
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\compare_matrix_float.asm
; @Description: compare two matrix float nasm code on linux
;-------------------------------------------------------------

global is_equal_matrix_float

extern printf
extern puts

section .rodata
    epsilon       dd 1e-6
    abs_mask      dd 0x7FFFFFFF
    invalid_param db "Invalid param!", 10, 0
    dim_mismatch  db "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0

section .text

; bool is_equal_matrix_float(MatrixFloat *m1, MatrixFloat *m2)
; rdi = m1, rsi = m2 (System V)
is_equal_matrix_float:

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

    cmp r8, r10
    jne dimension_mismatch
    cmp r9, r11
    jne dimension_mismatch

    xor rdi, rdi
    mov rsi, r8
    imul rsi, r9
    mov r10, [r14]
    mov r11, [r15]
    movss xmm2, [rel epsilon]
    movd xmm3, [rel abs_mask]

loop1:
    cmp rdi, rsi
    jge true_end

    movss xmm0, [r10 + rdi * 4]
    subss xmm0, [r11 + rdi * 4]
    andps xmm0, xmm3

    comiss xmm0, xmm2
    jae false_end

    inc rdi
    jmp loop1

true_end:
    mov rax, 1
    jmp cleanup

false_end:
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

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
