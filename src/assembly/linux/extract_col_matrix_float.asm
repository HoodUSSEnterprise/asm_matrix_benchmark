;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:41:23
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:42:54
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\extract_col_matrix_float.asm
; @Description: extract col matrix float nasm code on linux
;-------------------------------------------------------------

global extract_col_float

extern malloc
extern free
extern printf

section .rodata
    invalid_param db "Invalid param!", 10, 0
    malloc_failed db "Memory allocation failed", 10, 0

section .text

; MatrixFloat *extract_col_float(MatrixFloat *m, size_t index);
; rdi = m, rsi = index (System V)
extract_col_float:

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

    mov r14, [rdi]
    test r14, r14
    jz null_ptr

    mov r14, rdi

    mov r8, [r14 + 16]

    cmp r15, r8
    jge null_ptr

    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov rdi, [r14 + 8]
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax
    mov r10, [r14 + 8]
    mov [rbx + 8], r10
    mov qword [rbx + 16], 1

    xor rsi, rsi
    mov rdi, [r14 + 8]
    mov r12, [rbx]
    mov r10, [r14 + 16]
    mov r13, [r14]

loop1:
    cmp rsi, rdi
    jge end

    mov r8, rsi
    imul r8, r10
    add r8, r15

    movss xmm0, [r13 + r8 * 4]
    movss [r12 + rsi * 4], xmm0

    inc rsi
    jmp loop1

end:
    mov rax, rbx
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

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
