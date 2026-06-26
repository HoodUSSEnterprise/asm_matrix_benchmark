; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 18:52:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:21:14
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\double\replace_matrix_double_by_value.asm
; @Description: replace matrix double by value nasm code on windows
; -------------------------------------------------------------

global replace_matrix_double_by_value

; bool find_elem_double(MatrixDouble *m, double elem, Point *pos);
; rcx = m, xmm1 = elem, r8 = pos
extern find_elem_double
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 0    ; invalid param msg

section .text

; bool replace_matrix_double_by_value(MatrixDouble *m, double old_data, double new_data);
; rcx = m, xmm1 = old_data, xmm2 = new_data

replace_matrix_double_by_value:
    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 64                         ; allocate shadow space for puts

    movsd [rsp + 48], xmm15
    movsd [rsp + 56], xmm14

    mov r14, rcx                        ; r14 = m
    movsd xmm15, xmm1                   ; xmm15 = old_data
    movsd xmm14, xmm2                   ; save new_data on stack

    ; check m
    test r14, r14
    jz null_ptr

    mov r14, [rcx]                      ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    mov rcx, r14
    movsd xmm1, xmm15
    lea r8, [rsp + 32]
    call find_elem_double
    cmp rax, 0
    je no_find

    mov rsi, [r14]                      ; rsi = m->data
    ; calc index of array
    mov r10, [r14 + 16]                 ; r10 = m->cols
    imul r10, [rsp + 32]                ; pos.x * m->cols
    add r10, [rsp + 40]                 ; pos.x * m->cols + pos.y

    movsd [rsi + r10 * 8], xmm14        ; m->data[pos.x * m->cols + pos.y] = new_data

loop_replace:
    mov rcx, r14
    movsd xmm1, xmm15
    lea r8, [rsp + 32]
    call find_elem_double
    cmp rax, 1
    je replace_data
    jne end

replace_data:
    ; calc index of array
    mov r10, [r14 + 16]                 ; r10 = m->cols
    imul r10, [rsp + 32]                ; pos.x * m->cols
    add r10, [rsp + 40]                 ; pos.x * m->cols + pos.y

    movsd [rsi + r10 * 8], xmm14        ; m->data[pos.x * m->cols + pos.y] = new_data
    jmp loop_replace

null_ptr:
    lea rcx, [rel invalid_param]        ; rcx = invalid_param
    call puts
    mov rax, 0                          ; return false
    jmp cleanup

no_find:
    mov rax, 0
    jmp cleanup

end:
    mov rax, 1

cleanup:

    movsd xmm15, [rsp + 48]
    movsd xmm14, [rsp + 56]
    add rsp, 64                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    ret
