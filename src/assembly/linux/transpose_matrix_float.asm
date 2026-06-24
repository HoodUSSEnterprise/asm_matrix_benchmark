;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:38:22
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:41:58
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\transpose_matrix_float.asm
; @Description: get transpose matrix float nasm code on linux
;-------------------------------------------------------------

global transpose_matrix_float
extern malloc
extern free
extern printf

section .rodata
    malloc_failed db "Memory allocation failed", 10, 0
    invalid_param db "Invalid param!", 10, 0

section .text

; MatrixFloat *transpose_matrix_float(MatrixFloat *m);
; rdi = m (System V)

transpose_matrix_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi

    test r14, r14
    jz null_ptr

    mov r14, [rdi]
    test r14, r14
    jz null_ptr

    mov r14, rdi

    mov rdi, [r14 + 8]
    imul rdi, [r14 + 16]
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
    mov [rbx + 8], r10
    mov [rbx + 16], r9

    xor rdi, rdi
    mov r11, [r14]
    mov r12, [rbx]

loop1:
    cmp rdi, r10
    jge end
    xor rsi, rsi
    loop2:
        cmp rsi, r9
        jge inc_rdi

        mov r8, r10
        imul r8, rsi
        add r8, rdi

        movss xmm0, [r11 + r8 * 4]

        mov r8, r9
        imul r8, rdi
        add r8, rsi

        movss [r12 + r8 * 4], xmm0
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
