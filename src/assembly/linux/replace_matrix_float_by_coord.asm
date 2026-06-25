;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:41:23
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-25 15:37:22
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\replace_matrix_float_by_coord.asm
; @Description: replace matrix float by coord nasm code on linux
;-------------------------------------------------------------

global replace_matrix_float_by_coord
extern puts

section .rodata
    invalid_param db "Invalid param!", 0
    index_out db "index out of range", 0

section .text

; bool replace_matrix_float_by_coord(MatrixFloat *m, Point *pos, float new_data);
; rdi = m, rsi = pos, xmm0 = new_data (System V)
replace_matrix_float_by_coord:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40

    movss [rsp + 36], xmm14

    mov r14, rdi
    mov r15, rsi
    movss xmm14, xmm0

    ; check m and pos
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    mov r14, [rdi]

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rdi

    mov r8, [r15]
    mov r9, [r15 + 8]

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
    mov r10, [r14 + 16]
    imul r10, r8
    add r10, r9

    ; change value
    mov r8, [r14]
    movss [r8 + r10 * 4], xmm14
    mov rax, 1
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

index_out_of_range:
    lea rdi, [rel index_out]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

cleanup:

    movss xmm14, [rsp + 36]
    add rsp, 40
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
