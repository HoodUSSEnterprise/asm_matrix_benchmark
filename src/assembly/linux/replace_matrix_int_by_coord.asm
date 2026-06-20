;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-17 13:23:47
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-17 13:48:38
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\replace_matrix_int_by_coord.asm
; @Description: replace matrix by coord nasm code on windows
;-------------------------------------------------------------
global replace_matrix_int_by_coord
extern puts

section .rodata
    invalid_param db "Invalid param!", 0                                   ; invalid param msg
    index_out db "index out of range", 0

section .text

; bool replace_matrix_int_by_coord(MatrixInt *m, Point *pos, int new_data);
; rcx = m, rdx = pos, r8d = new_data
replace_matrix_int_by_coord:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32 ; allocate shadow space for puts

    mov r14, rcx ; r14 = m
    mov r15, rdx ; r15 = pos
    mov r13d, r8d ; r13d = new_data

    ; check m and pos
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    mov r14, [rcx] ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    mov r8, [r15] ; r8 = pos.x
    mov r9, [r15 + 8] ; r9 = pos.y

    ; check x and y range
    ; x and y must greater than 0
    cmp r8, 0
    jl index_out_of_range
    cmp r9, 0
    jl index_out_of_range
    
    ; x and y must in matrix size
    ; x needs to less than m->cols(no equal)
    cmp r8, [r14 + 16]
    jg index_out_of_range
    ; y needs to less than m->rows(no equal)
    cmp r9, [r14 + 8]
    jg index_out_of_range

    ; calc index of array
    mov r10, [r14 + 16] ; r10 = m->cols
    imul r10, r8 ; pos.x * m->cols
    add r10, r9 ; pos.x * m->cols + pos.y

    ; change value
    mov r8, [r14] ; r8 = m->data
    mov [r8 + r10 * 4], r13d ; m->data[pos.x * m->cols + pos.y] = new_data
    mov rax, 1
    jmp cleanup

null_ptr:
    lea rcx, [rel invalid_param] ; rcx = invalid_param
    call puts
    mov rax, 0 ; return false
    jmp cleanup

index_out_of_range:
    lea rcx, [rel index_out]
    call puts
    mov rax, 0 ; return false
    jmp cleanup

cleanup:
    add rsp, 32 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    ret