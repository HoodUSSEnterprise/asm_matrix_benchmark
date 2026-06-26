; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:46:00
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:17:36
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\float\lu_matrix_float.asm
; @Description: lu decomposition float nasm code on linux
; -------------------------------------------------------------

global LU_Decomposition_float
extern printf
extern puts
extern malloc
extern free
extern get_leading_minors_float
extern rank_matrix_float

section .rodata
    zero           dq  0.0
    one            dq  1.0
    malloc_failed  db  "Memory allocation failed", 0
    invalid_param  db  "Invalid param!", 0
    not_square     db  "It's not a square", 0
    wrong_lm       db  "function get_leading_minors_float has a wrong value", 0
    cant_lu        db  "This matrix can't lu decomposition", 0

section .text

; bool LU_Decomposition_float(MatrixFloat *m, LU_Result *res);
; rdi = m, rsi = res (System V)

LU_Decomposition_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi
    mov rbx, rsi

    test r14, r14
    jz null_ptr

    mov r14, [rdi]

    test r14, r14
    jz null_ptr

    mov r14, rdi

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    cmp r8, r9
    jne not_a_square

    ; ========== get leading minors ==========
    mov rdi, r14
    call get_leading_minors_float wrt ..plt
    test rax, rax
    jz wrong_leading_minors

    mov r15, rax

    mov r8, [r14 + 8]

    xor r12, r12

check_lm_loop:
    cmp r12, [r15 + 8]
    jae check_lm_done

    mov rax, [r15]
    mov rdi, r12
    imul rdi, 24
    add rdi, rax

    lea rsi, [rsp + 24]
    call rank_matrix_float wrt ..plt
    test rax, rax
    jz check_lm_fail

    movsxd rax, dword[rsp + 24]
    lea rdx, [r12 + 1]
    cmp rax, rdx
    jne check_lm_fail

    inc r12
    jmp check_lm_loop

check_lm_done:
    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    ; ========== allocate L (MatrixFloat) ==========
    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_L

    mov r12, rax

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    mov [r12 + 8], r8
    mov [r12 + 16], r9

    ; ========== allocate L->data ==========
    mov rax, r8
    imul rax, r9
    mov r13, rax
    shl rax, 3
    mov rdi, rax
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_Ldata

    mov [r12], rax

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    ; ========== allocate U (MatrixFloat) ==========
    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_U

    mov r13, rax

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    mov [r13 + 8], r8
    mov [r13 + 16], r9

    ; ========== allocate U->data ==========
    mov rax, r8
    imul rax, r9
    shl rax, 3
    mov rdi, rax
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_Udata

    mov [r13], rax

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    ; ========== check if res == NULL (auto-allocate) ==========
    mov qword[rsp + 24], 0

    test rbx, rbx
    jnz alloc_done

    mov edi, 16
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_res

    mov rbx, rax
    mov qword[rsp + 24], 1

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

alloc_done:

    ; ========== load pointers ==========
    mov r9, [r14]
    mov r10, [r12]
    mov r11, [r13]

    ; ========== init L: upper triangle = 0, diagonal = 1 ==========
    xor rdi, rdi

init_L_i:
    cmp rdi, r8
    jge init_L_done

    xor rsi, rsi

    init_L_j:
        cmp rsi, r8
        jge init_L_i_inc

        mov rax, rdi
        imul rax, r8
        add rax, rsi

        cmp rsi, rdi
        je L_set_one
        movsd xmm0, [rel zero]
        movsd [r10 + rax * 8], xmm0
        jmp next

    L_set_one:
        movsd xmm0, [rel one]
        movsd [r10 + rax * 8], xmm0

    next:
        inc rsi
        jmp init_L_j

init_L_i_inc:
    inc rdi
    jmp init_L_i

init_L_done:

    ; ========== init U: first row = m[0][*] as double ==========
    xor rsi, rsi

init_U_first_row:
    cmp rsi, r8
    jge init_U_lower

    cvtss2sd xmm0, [r9 + rsi * 4]
    movsd [r11 + rsi * 8], xmm0

    inc rsi
    jmp init_U_first_row

init_U_lower:
    xor rdi, rdi

init_U_lower_i:
    cmp rdi, r8
    jge init_U_done

    xor rsi, rsi

    init_U_lower_j:
        cmp rsi, rdi
        jge init_U_lower_i_inc

        mov rax, rdi
        imul rax, r8
        add rax, rsi
        movsd xmm0, [rel zero]
        movsd [r11 + rax * 8], xmm0

        inc rsi
        jmp init_U_lower_j

init_U_lower_i_inc:
    inc rdi
    jmp init_U_lower_i

init_U_done:

    ; ========== compute l_i0 = a_i0 / u_00 for i = 1..n-1 ==========
    movsd xmm1, [r11]

    mov rdi, 1

compute_l_i0:
    cmp rdi, r8
    jge compute_l_done

    mov rax, rdi
    imul rax, r8
    cvtss2sd xmm0, [r9 + rax * 4]
    divsd xmm0, xmm1

    mov rax, rdi
    imul rax, r8
    movsd [r10 + rax * 8], xmm0

    inc rdi
    jmp compute_l_i0

compute_l_done:

    ; ========== Doolittle main loop ==========
    mov rdi, 1

doolittle_loop_i:
    cmp rdi, r8
    jge doolittle_done

    mov rsi, rdi

    doolittle_u_j:
        cmp rsi, r8
        jge doolittle_l_start

        xorpd xmm4, xmm4
        xor rcx, rcx

        doolittle_u_sum:
            cmp rcx, rdi
            jge doolittle_u_store

            mov rax, rdi
            imul rax, r8
            add rax, rcx
            movsd xmm0, [r10 + rax * 8]

            mov rax, rcx
            imul rax, r8
            add rax, rsi
            mulsd xmm0, [r11 + rax * 8]

            addsd xmm4, xmm0
            inc rcx
            jmp doolittle_u_sum

    doolittle_u_store:
        mov rax, rdi
        imul rax, r8
        add rax, rsi
        cvtss2sd xmm0, [r9 + rax * 4]
        subsd xmm0, xmm4

        mov rax, rdi
        imul rax, r8
        add rax, rsi
        movsd [r11 + rax * 8], xmm0

        inc rsi
        jmp doolittle_u_j

    doolittle_l_start:
        lea rsi, [rdi + 1]

    doolittle_l_j:
        cmp rsi, r8
        jge doolittle_i_inc

        xorpd xmm4, xmm4
        xor rcx, rcx

    doolittle_l_sum:
        cmp rcx, rsi
        jge doolittle_l_store

        mov rax, rsi
        imul rax, r8
        add rax, rcx
        movsd xmm0, [r10 + rax * 8]

        mov rax, rcx
        imul rax, r8
        add rax, rdi
        mulsd xmm0, [r11 + rax * 8]

        addsd xmm4, xmm0
        inc rcx
        jmp doolittle_l_sum

    doolittle_l_store:
        mov rax, rsi
        imul rax, r8
        add rax, rdi
        cvtss2sd xmm0, [r9 + rax * 4]
        subsd xmm0, xmm4

        mov rax, rdi
        imul rax, r8
        add rax, rdi
        divsd xmm0, [r11 + rax * 8]

        mov rax, rsi
        imul rax, r8
        add rax, rdi
        movsd [r10 + rax * 8], xmm0

        inc rsi
        jmp doolittle_l_j

doolittle_i_inc:
    inc rdi
    jmp doolittle_loop_i

doolittle_done:

    ; ========== store L and U in res ==========
    mov [rbx], r12
    mov [rbx + 8], r13

    ; ========== free leading_minors (fix: use r12 as counter, not rcx/rdi) ==========
    xor r12, r12

free_lm_data:
    cmp r12, [r15 + 8]
    jae free_lm_array

    mov rax, r12
    imul rax, 24
    mov rdi, [r15]
    mov rdi, [rdi + rax]
    test rdi, rdi
    jz free_lm_next
    call free wrt ..plt

free_lm_next:
    inc r12
    jmp free_lm_data

free_lm_array:
    mov rdi, [r15]
    call free wrt ..plt
    mov rdi, r15
    call free wrt ..plt

    mov rax, 1
    jmp cleanup

; ========== error handlers ==========
null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    xor eax, eax
    jmp cleanup

not_a_square:
    lea rdi, [rel not_square]
    call puts wrt ..plt
    xor eax, eax
    jmp cleanup

wrong_leading_minors:
    lea rdi, [rel wrong_lm]
    call puts wrt ..plt
    xor eax, eax
    jmp cleanup

check_lm_fail:
    lea rdi, [rel cant_lu]
    call puts wrt ..plt

free_lm_and_fail:
    xor r12, r12

free_lm_fail_data:
    cmp r12, [r15 + 8]
    jae free_lm_fail_array

    mov rax, r12
    imul rax, 24
    mov rdi, [r15]
    mov rdi, [rdi + rax]
    test rdi, rdi
    jz free_lm_fail_next
    call free wrt ..plt

free_lm_fail_next:
    inc r12
    jmp free_lm_fail_data

free_lm_fail_array:
    mov rdi, [r15]
    call free wrt ..plt
    mov rdi, r15
    call free wrt ..plt
    xor eax, eax
    jmp cleanup

malloc_fail_L:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    jmp free_lm_and_fail

malloc_fail_Ldata:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, r12
    call free wrt ..plt
    jmp free_lm_and_fail

malloc_fail_U:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, [r12]
    call free wrt ..plt
    mov rdi, r12
    call free wrt ..plt
    jmp free_lm_and_fail

malloc_fail_Udata:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, [r12]
    call free wrt ..plt
    mov rdi, r12
    call free wrt ..plt
    mov rdi, r13
    call free wrt ..plt
    jmp free_lm_and_fail

malloc_fail_res:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, [r12]
    call free wrt ..plt
    mov rdi, r12
    call free wrt ..plt
    mov rdi, [r13]
    call free wrt ..plt
    mov rdi, r13
    call free wrt ..plt
    jmp free_lm_and_fail

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
