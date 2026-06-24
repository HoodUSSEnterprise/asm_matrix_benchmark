;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:43:50
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:44:05
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\leading_minors_float.asm
; @Description: get leading principal minor float nasm code on linux
;-------------------------------------------------------------

global get_leading_minors_float
extern printf
extern puts
extern malloc
extern free

section .rodata
    malloc_failed db "Memory allocation failed", 0
    invalid_param db "Invalid param!", 0
    not_square    db "It's not a square", 0

section .text

; Leading_Minors_Float *get_leading_minors_float(MatrixFloat *m);
; rdi = m (System V)
get_leading_minors_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 48

    mov r14, rdi

    test r14, r14
    jz null_ptr

    mov r14, [rdi]

    test r14, r14
    jz null_ptr

    mov r14, rdi

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    cmp r8, 0
    je null_ptr
    cmp r9, 0
    je null_ptr

    cmp r8, r9
    jne not_a_square

    ; ========== allocate res (Leading_Minors_Float) ==========
    mov edi, 16
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov r8, [r14 + 8]
    mov r15, rax
    mov [r15 + 8], r8

    ; ========== allocate matrix_data array ==========
    mov rdi, r8
    imul rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_matrix_data

    mov [r15], rax
    mov r12, rax

    ; ========== init m->data pointer ==========
    mov r13, [r14]
    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    ; ========== loop order = 1..m->rows ==========

    mov qword [rsp + 24], 0 ; successful_count = 0
    mov rbx, 1

order_loop:
    mov r8, [r14 + 8]
    cmp rbx, r8
    ja all_done

    mov r10, rbx
    dec r10

    mov rax, r10
    imul rax, 24
    lea r11, [r12 + rax]

    mov [r11 + 8], rbx
    mov [r11 + 16], rbx

    mov [rsp + 32], r11
    mov rdi, rbx
    imul rdi, rbx
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_subdata

    mov r11, [rsp + 32]
    mov [r11], rax

    mov qword [rsp + 24], rbx ; successful_count = order

    xor rcx, rcx
    mov rdx, [r11]
    copy_loop_i:
        cmp rcx, rbx
        jge copy_done

        xor rsi, rsi

        copy_loop_j:
            cmp rsi, rbx
            jge copy_inc_i

            mov rax, rcx
            imul rax, [r14 + 16]
            add rax, rsi
            movss xmm0, [r13 + rax * 4]

            mov rax, rcx
            imul rax, rbx
            add rax, rsi

            movss [rdx + rax * 4], xmm0

            inc rsi
            jmp copy_loop_j

    copy_inc_i:

        inc rcx
        jmp copy_loop_i

    copy_done:

        inc rbx
        jmp order_loop

all_done:

    mov rax, r15
    jmp cleanup

; ========== malloc failure handling ==========
malloc_fail_struct:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_matrix_data:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, r15
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_subdata:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    xor rsi, rsi

    free_subdata_loop:
        cmp rsi, [rsp + 24] ; i < successful_count?
        jae free_subdata_done

        mov rax, rsi
        imul rax, 24
        mov r8, [r12 + rax]
        test r8, r8
        jz free_subdata_next
        mov rdi, r8
        call free wrt ..plt

    free_subdata_next:
        inc rsi
        jmp free_subdata_loop

free_subdata_done:
    mov rdi, r12
    call free wrt ..plt
    mov rdi, r15
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

not_a_square:
    lea rdi, [rel not_square]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

cleanup:
    add rsp, 48
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
