;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:43:48
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:44:31
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\special_matrix_float.asm
; @Description: some special matrix like identity matrix, diag matrix,
; eye_matrix and zero matrix float nasm code on linux
;-------------------------------------------------------------

global identity_matrix_float, diag_matrix_float, eye_matrix_float, zero_matrix_float
extern malloc
extern free
extern puts
extern memset

section .rodata
    malloc_failed db "Memory allocation failed", 0
    invalid_param db "Invalid param!", 0
    one_float dd 1.0

section .text

; ---------------------------------------------------------------------------------------------
; MatrixFloat *identity_matrix_float(int order);
; edi = order
; ---------------------------------------------------------------------------------------------
identity_matrix_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14d, edi

    cmp r14d, 0
    jle null_ptr

    mov rdi, r14
    imul rdi, r14
    mov r12, rdi

    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov rdi, r12
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov r13, rax
    mov rdi, r13
    mov esi, 0
    mov rdx, r12
    shl rdx, 2
    call memset wrt ..plt

    mov [rbx], r13
    mov [rbx + 8], r14
    mov [rbx + 16], r14

    xor ecx, ecx
    mov rsi, [rbx]
    movss xmm0, [rel one_float]

loopidentity:
    cmp rcx, r14
    jge end

    mov r8, r14
    imul r8, rcx
    add r8, rcx

    movss [rsi + r8 * 4], xmm0
    inc rcx
    jmp loopidentity

; ---------------------------------------------------------------------------------------------
; MatrixFloat *diag_matrix_float(float *data, size_t len);
; rdi = data, rsi = len
; ---------------------------------------------------------------------------------------------
diag_matrix_float:

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
    cmp r15, 0
    jle null_ptr

    mov rdi, r15
    imul rdi, r15
    mov r12, rdi

    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov rdi, r12
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov r13, rax
    mov rdi, r13
    mov esi, 0
    mov rdx, r12
    shl rdx, 2
    call memset wrt ..plt

    mov [rbx], r13
    mov [rbx + 8], r15
    mov [rbx + 16], r15

    xor ecx, ecx
    mov rsi, [rbx]

loopdiag:
    cmp rcx, r15
    jge end

    mov r8, r15
    imul r8, rcx
    add r8, rcx

    movss xmm0, [r14 + rcx * 4]
    movss [rsi + r8 * 4], xmm0
    inc rcx
    jmp loopdiag

; ---------------------------------------------------------------------------------------------
; MatrixFloat *eye_matrix_float(int rows, int cols);
; edi = rows, esi = cols
; ---------------------------------------------------------------------------------------------
eye_matrix_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14d, edi
    mov r15d, esi

    cmp r14d, 0
    jle null_ptr
    cmp r15d, 0
    jle null_ptr

    mov edi, r14d
    imul edi, r15d
    mov r12d, edi

    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov edi, r12d
    shl edi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov r13, rax
    mov rdi, r13
    mov esi, 0
    mov edx, r12d
    shl edx, 2
    call memset wrt ..plt

    mov [rbx], r13
    mov [rbx + 8], r14
    mov [rbx + 16], r15

    xor ecx, ecx
    mov rsi, [rbx]
    movss xmm0, [rel one_float]

    cmp r14d, r15d
    jge select_r15d
    mov r9, r14
    jmp loopeye

select_r15d:
    mov r9, r15

loopeye:
    cmp rcx, r9
    jge end

    mov r8, r15
    imul r8, rcx
    add r8, rcx

    movss [rsi + r8 * 4], xmm0
    inc rcx
    jmp loopeye

; ---------------------------------------------------------------------------------------------
; MatrixFloat *zero_matrix_float(int rows, int cols);
; edi = rows, esi = cols
; ---------------------------------------------------------------------------------------------
zero_matrix_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14d, edi
    mov r15d, esi

    cmp r14, 0
    jle null_ptr
    cmp r15, 0
    jle null_ptr

    mov edi, r14d
    imul edi, r15d
    mov r12d, edi

    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov edi, r12d
    shl edi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov r13, rax
    mov rdi, r13
    mov esi, 0
    mov edx, r12d
    shl edx, 2
    call memset wrt ..plt

    mov [rbx], r13
    mov [rbx + 8], r14
    mov [rbx + 16], r15
    jmp end

malloc_fail_struct:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
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
