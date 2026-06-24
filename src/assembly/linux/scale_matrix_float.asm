;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:38:22
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:41:31
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\scale_matrix_float.asm
; @Description: scale matrix float nasm code on linux
;-------------------------------------------------------------

global scale_matrix_float
extern printf
extern malloc
extern free

section .rodata
    malloc_failed db "Memory allocation failed", 10, 0
    invalid_param db "Invalid param!", 10, 0

section .text

; MatrixFloat *scale_matrix_float(MatrixFloat *m, float scale);
; rdi = m, xmm0 = scale (System V)

scale_matrix_float:
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi
    movss xmm15, xmm0

    test r14, r14
    jz null_ptr

    mov r14, [rdi]
    test r14, r14
    jz null_ptr

    mov r14, rdi

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

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

on_loop:
    cmp rcx, rdi
    jge end

    movss xmm0, [r9 + rcx * 4]
    mulss xmm0, xmm15
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
