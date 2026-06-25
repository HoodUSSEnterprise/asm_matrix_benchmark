;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:41:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-25 15:37:32
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\replace_matrix_float_by_value.asm
; @Description: replace matrix float by value nasm code on linux
;-------------------------------------------------------------

global replace_matrix_float_by_value

; bool find_elem_float(MatrixFloat *m, float elem, Point *pos);
; rdi = m, xmm0 = elem, rsi = pos (System V)
extern find_elem_float
extern puts

section .rodata
    invalid_param db "Invalid param!", 0

section .text

; bool replace_matrix_float_by_value(MatrixFloat *m, float old_data, float new_data);
; rdi = m, xmm0 = old_data, xmm1 = new_data (System V)
replace_matrix_float_by_value:
    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 56

    movss [rsp + 48], xmm15

    mov r14, rdi
    movss xmm15, xmm0
    movss [rsp + 24], xmm1     ; new_data at safe stack offset

    ; check m
    test r14, r14
    jz null_ptr

    mov r14, [rdi]

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rdi

    mov rdi, r14
    movss xmm0, xmm15
    lea rsi, [rsp + 32]
    call find_elem_float wrt ..plt
    cmp rax, 0
    je no_find

    mov rsi, [r14]
    ; calc index of array
    mov r10, [r14 + 16]
    imul r10, [rsp + 32]
    add r10, [rsp + 40]

    movss xmm0, [rsp + 24]
    movss [rsi + r10 * 4], xmm0

loop_replace:
    mov rdi, r14
    movss xmm0, xmm15
    lea rsi, [rsp + 32]
    call find_elem_float wrt ..plt
    cmp rax, 1
    je replace_data
    jne end

replace_data:
    ; calc index of array
    mov r10, [r14 + 16]
    imul r10, [rsp + 32]
    add r10, [rsp + 40]

    movss xmm0, [rsp + 24]
    mov rsi, [r14]              ; rsi = m->data (reload after call)
    movss [rsi + r10 * 4], xmm0
    jmp loop_replace

null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

no_find:
    mov rax, 0
    jmp cleanup

end:
    mov rax, 1

cleanup:
    movss xmm15, [rsp + 48]
    add rsp, 56
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
