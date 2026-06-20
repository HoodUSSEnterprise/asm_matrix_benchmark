;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-20 16:10:25
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-20 17:05:24
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\replace_matrix_int_by_value.asm
; @Description: replace matrix int by value nasm code on linux
;-------------------------------------------------------------

global replace_matrix_int_by_value

; bool find_elem_int(MatrixInt *m, int elem, Point *pos);
; rcx = m, edx = elem, r8 = pos
extern find_elem_int
extern puts

section .rodata
    invalid_param db "Invalid param!", 0                                   ; invalid param msg

section .text

; bool replace_matrix_int_by_value(MatrixInt *m, int old_data, int new_data);
; rdi = m, rsi = old_data, rdx = new_data (System V)
replace_matrix_int_by_value:
    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 48 ; allocate shadow space for puts

    mov r14, rdi ; r14 = m
    mov r15d, esi ; r15d = old_data
    mov r13d, edx ; r13d = new_data

    ; check m
    test r14, r14
    jz null_ptr

    mov r14, [rdi] ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    mov rdi, r14
    mov esi, r15d
    lea rdx, [rsp + 32]
    call find_elem_int
    cmp rax, 0
    je no_find

    mov rsi, [r14] ; rsi = m->data
    ; calc index of array
    mov r10, [r14 + 16] ; r10 = m->cols
    imul r10, [rsp + 32] ; pos.x * m->cols
    add r10, [rsp + 40] ; pos.x * m->cols + pos.y

    mov [rsi + r10 * 4], r13d ; m->data[pos.x * m->cols + pos.y] = new_data

loop_replace:
    mov rdi, r14
    mov esi, r15d
    lea rdx, [rsp + 32]
    call find_elem_int
    cmp rax, 1
    je replace_data
    jne end

replace_data:
    ; calc index of array
    mov r10, [r14 + 16] ; r10 = m->cols
    imul r10, [rsp + 32] ; pos.x * m->cols
    add r10, [rsp + 40] ; pos.x * m->cols + pos.y

    mov [rsi + r10 * 4], r13d ; m->data[pos.x * m->cols + pos.y] = new_data
    jmp loop_replace

null_ptr:
    lea rdi, [rel invalid_param] ; rdi = invalid_param
    sub rsp, 8
    call puts
    add rsp, 8
    mov rax, 0 ; return false
    jmp cleanup

no_find:
    mov rax, 0
    jmp cleanup

end:
    mov rax, 1

cleanup:
    add rsp, 48 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    ret