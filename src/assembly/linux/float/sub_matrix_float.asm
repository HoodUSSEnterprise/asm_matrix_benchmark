; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:38:22
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:18:02
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\float\sub_matrix_float.asm
; @Description: sub matrix float nasm code on linux
; -------------------------------------------------------------

global sub_matrix_float
extern printf
extern malloc
extern free

section .rodata
    malloc_failed  db  "Memory allocation failed", 10, 0
    invalid_param  db  "Invalid param!", 10, 0
    dim_mismatch   db  "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0

section .text

; MatrixFloat *sub_matrix_float(MatrixFloat *m1, MatrixFloat *m2);
; rdi = m1, rsi = m2 (System V)

sub_matrix_float:

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

    mov rdi, r8
    imul rdi, r9
    mov r12, rdi

    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov rdi, r12
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax
    mov r9, [r14 + 8]
    mov r10, [r14 + 16]
    mov [rbx + 8], r9
    mov [rbx + 16], r10

    mov rdi, r12
    xor rcx, rcx
    mov r13, [rbx]
    mov r9, [r14]
    mov r10, [r15]

on_loop:
    cmp rcx, rdi
    jge end

    movss xmm0, [r9 + rcx * 4]
    subss xmm0, [r10 + rcx * 4]
    movss [r13 + rcx * 4], xmm0
    inc rcx
    jmp on_loop

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
