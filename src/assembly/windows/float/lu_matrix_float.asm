; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 18:52:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:21:52
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\float\lu_matrix_float.asm
; @Description:  lu decomposition float nasm code on windows
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
; rcx = m, rdx = res

LU_Decomposition_float:

    ; save callee_register
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space

    mov r14, rcx                        ; r14 = m
    mov rbx, rdx                        ; rbx = res

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rcx]                      ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    ; check dimension (square matrix)
    mov r8, [r14 + 8]                   ; r8 = m->rows
    mov r9, [r14 + 16]                  ; r9 = m->cols

    cmp r8, r9                          ; m->rows == m->cols?
    jne not_a_square

    ; ========== get leading minors ==========
    mov rcx, r14
    call get_leading_minors_float
    test rax, rax
    jz wrong_leading_minors

    mov r15, rax                        ; r15 = leading_minors

    ; reload r8 after call
    mov r8, [r14 + 8]                   ; r8 = m->rows

    ; check each leading minor rank == order
    xor r12, r12                        ; i = 0

check_lm_loop:
    cmp r12, [r15 + 8]                  ; i < leading_minors->len?
    jae check_lm_done

    ; &leading_minors->matrix_data[i]
    mov rax, [r15]                      ; rax = matrix_data array pointer
    mov rcx, r12                        ; rcx = i (for Windows calling convention)
    imul rcx, 24                        ; rcx = i * sizeof(MatrixFloat)
    add rcx, rax                        ; rcx = &matrix_data[i]

    lea rdx, [rsp + 24]                 ; rdx = &rank (local var)
    call rank_matrix_float
    test rax, rax
    jz check_lm_fail

    movsxd rax, dword[rsp + 24]         ; rax = rank
    lea rdx, [r12 + 1]                  ; rdx = i + 1
    cmp rax, rdx                        ; rank == i + 1?
    jne check_lm_fail

    inc r12                             ; i++
    jmp check_lm_loop

check_lm_done:
    ; reload r8, r9 after calls
    mov r8, [r14 + 8]                   ; r8 = m->rows
    mov r9, [r14 + 16]                  ; r9 = m->cols

    ; ========== allocate L (MatrixDouble) ==========
    mov rcx, 24
    call malloc
    test rax, rax
    jz malloc_fail_L

    mov r12, rax                        ; r12 = L

    ; reload r8, r9 after malloc call
    mov r8, [r14 + 8]                   ; r8 = m->rows
    mov r9, [r14 + 16]                  ; r9 = m->cols

    mov [r12 + 8], r8                   ; L->rows = m->rows
    mov [r12 + 16], r9                  ; L->cols = m->cols

    ; ========== allocate L->data ==========
    mov rax, r8                         ; rax = m->rows
    imul rax, r9                        ; rax = m->rows * m->cols
    mov r13, rax                        ; r13 = element count
    shl rax, 3                          ; rax *= 8 (sizeof double)
    mov rcx, rax
    call malloc
    test rax, rax
    jz malloc_fail_Ldata

    mov [r12], rax                      ; L->data = new malloc data

    ; reload r8, r9 after malloc call
    mov r8, [r14 + 8]                   ; r8 = m->rows
    mov r9, [r14 + 16]                  ; r9 = m->cols

    ; ========== allocate U (MatrixDouble) ==========
    mov rcx, 24
    call malloc
    test rax, rax
    jz malloc_fail_U

    mov r13, rax                        ; r13 = U

    ; reload r8, r9 after malloc call
    mov r8, [r14 + 8]                   ; r8 = m->rows
    mov r9, [r14 + 16]                  ; r9 = m->cols

    mov [r13 + 8], r8                   ; U->rows = m->rows
    mov [r13 + 16], r9                  ; U->cols = m->cols

    ; ========== allocate U->data ==========
    mov rax, r8                         ; rax = m->rows
    imul rax, r9                        ; rax = m->rows * m->cols
    shl rax, 3                          ; rax *= 8 (sizeof double)
    mov rcx, rax
    call malloc
    test rax, rax
    jz malloc_fail_Udata

    mov [r13], rax                      ; U->data = new malloc data

    ; reload r8, r9 after malloc call
    mov r8, [r14 + 8]                   ; r8 = m->rows
    mov r9, [r14 + 16]                  ; r9 = m->cols

    ; ========== allocate LU_Result if res is NULL ==========
    mov qword[rsp + 24], 0              ; mark: did not allocate res

    test rbx, rbx
    jnz alloc_done

    mov rcx, 16                         ; sizeof(LU_Result)
    call malloc
    test rax, rax
    jz malloc_fail_res

    mov rbx, rax                        ; rbx = newly allocated res
    mov qword[rsp + 24], 1              ; mark: allocated res

    ; reload r8, r9 after malloc call
    mov r8, [r14 + 8]                   ; r8 = m->rows
    mov r9, [r14 + 16]                  ; r9 = m->cols

alloc_done:

    ; ========== load pointers for computation ==========
    mov r9, [r14]                       ; r9 = m->data (float*)
    mov r10, [r12]                      ; r10 = L->data (double*)
    mov r11, [r13]                      ; r11 = U->data (double*)
    ; r8 = n (= m->rows = m->cols)

    ; ========== init L: upper triangle = 0, diagonal = 1 ==========
    xor rdi, rdi                        ; i = 0

init_L_i:
    cmp rdi, r8                         ; i < n?
    jge init_L_done

    xor rsi, rsi                        ; j = 0

    init_L_j:
        cmp rsi, r8                     ; j < n?
        jge init_L_i_inc

        mov rax, rdi
        imul rax, r8
        add rax, rsi

        cmp rsi, rdi                    ; i == j?
        je L_set_one
        ; L->data[i * n + j] = 0.0
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
    xor rsi, rsi                        ; j = 0

init_U_first_row:
    cmp rsi, r8                         ; j < n?
    jge init_U_lower

    ; U->data[0 * n + j] = (double)m->data[0 * n + j]
    cvtss2sd xmm0, [r9 + rsi * 4]       ; m->data[0 * n + j] float -> double
    movsd [r11 + rsi * 8], xmm0         ; U->data[0 * n + j]

    inc rsi
    jmp init_U_first_row

    ; ========== init U: lower triangle = 0 ==========
init_U_lower:
    xor rdi, rdi                        ; i = 0

init_U_lower_i:
    cmp rdi, r8                         ; i < n?
    jge init_U_done

    xor rsi, rsi                        ; j = 0

    init_U_lower_j:
        cmp rsi, rdi                    ; j < i?
        jge init_U_lower_i_inc

        ; U->data[i * n + j] = 0.0
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
    movsd xmm1, [r11]                   ; xmm1 = U->data[0] = u_00

    mov rdi, 1                          ; i = 1

compute_l_i0:
    cmp rdi, r8                         ; i < n?
    jge compute_l_done

    ; load m->data[i * n + 0] as double
    mov rax, rdi
    imul rax, r8                        ; rax = i * n
    cvtss2sd xmm0, [r9 + rax * 4]       ; m->data[i * n + 0] float -> double
    divsd xmm0, xmm1                    ; xmm0 = m[i][0] / u_00

    ; store L->data[i * n + 0]
    mov rax, rdi
    imul rax, r8                        ; rax = i * n
    movsd [r10 + rax * 8], xmm0

    inc rdi
    jmp compute_l_i0

compute_l_done:

    ; ========== Doolittle main loop ==========
    ; for i = 1 to n-1:
    ;     for j = i to n-1:
    ;         U[i][j] = m[i][j] - Σ L[i][k] * U[k][j], k=0..j-1
    ;     for j = i+1 to n-1:
    ;         L[j][i] = (m[j][i] - Σ L[j][k] * U[k][i]) / U[i][i], k=0..j-1

    mov rdi, 1                          ; i = 1

doolittle_loop_i:
    cmp rdi, r8                         ; i < n?
    jge doolittle_done

    ; === sub-loop 1: U[i][j] for j = i..n-1 ===
    mov rsi, rdi                        ; j = i

    doolittle_u_j:
        cmp rsi, r8                     ; j < n?
        jge doolittle_l_start

        ; sum = Σ L[i][k] * U[k][j] for k = 0..j-1
        xorpd xmm4, xmm4                ; sum = 0.0
        xor rcx, rcx                    ; k = 0

        doolittle_u_sum:
            cmp rcx, rdi                ; k < i?
            jge doolittle_u_store

            ; L[i][k]
            mov rax, rdi
            imul rax, r8
            add rax, rcx
            movsd xmm0, [r10 + rax * 8]

            ; U[k][j]
            mov rax, rcx
            imul rax, r8
            add rax, rsi
            mulsd xmm0, [r11 + rax * 8]

            addsd xmm4, xmm0
            inc rcx
            jmp doolittle_u_sum

    doolittle_u_store:
        ; U[i][j] = (double)m[i][j] - sum
        mov rax, rdi
        imul rax, r8
        add rax, rsi
        cvtss2sd xmm0, [r9 + rax * 4]   ; m->data float -> double
        subsd xmm0, xmm4

        mov rax, rdi
        imul rax, r8
        add rax, rsi
        movsd [r11 + rax * 8], xmm0

        inc rsi                         ; j++
        jmp doolittle_u_j

    ; === sub-loop 2: L[j][i] for j = i+1..n-1 ===
    doolittle_l_start:
        lea rsi, [rdi + 1]              ; j = i + 1

    doolittle_l_j:
        cmp rsi, r8                     ; j < n?
        jge doolittle_i_inc

        ; sum = Σ L[j][k] * U[k][i] for k = 0..j-1
        xorpd xmm4, xmm4                ; sum = 0.0
        xor rcx, rcx                    ; k = 0

    doolittle_l_sum:
        cmp rcx, rsi                    ; k < j?
        jge doolittle_l_store

        ; L[j][k]
        mov rax, rsi
        imul rax, r8
        add rax, rcx
        movsd xmm0, [r10 + rax * 8]

        ; U[k][i]
        mov rax, rcx
        imul rax, r8
        add rax, rdi
        mulsd xmm0, [r11 + rax * 8]

        addsd xmm4, xmm0
        inc rcx
        jmp doolittle_l_sum

    doolittle_l_store:
        ; L[j][i] = ((double)m[j][i] - sum) / U[i][i]
        mov rax, rsi
        imul rax, r8
        add rax, rdi
        cvtss2sd xmm0, [r9 + rax * 4]   ; m->data float -> double
        subsd xmm0, xmm4

        ; divide by U[i][i]
        mov rax, rdi
        imul rax, r8
        add rax, rdi
        divsd xmm0, [r11 + rax * 8]

        ; store L[j][i]
        mov rax, rsi
        imul rax, r8
        add rax, rdi
        movsd [r10 + rax * 8], xmm0

        inc rsi                         ; j++
        jmp doolittle_l_j

doolittle_i_inc:
    inc rdi                             ; i++
    jmp doolittle_loop_i

doolittle_done:

    ; ========== store L and U in res ==========
    mov [rbx], r12                      ; res->L = L
    mov [rbx + 8], r13                  ; res->U = U
    ; ========== free leading_minors ==========
    xor r12, r12                        ; i = 0

free_lm_data:
    cmp r12, [r15 + 8]                  ; i < leading_minors->len?
    jae free_lm_array

    mov rax, r12
    imul rax, 24                        ; rax = i * sizeof(MatrixFloat)
    mov rdi, [r15]                      ; rdi = leading_minors->matrix_data
    mov rdi, [rdi + rax]                ; rdi = matrix_data[i].data
    test rdi, rdi
    jz free_lm_next
    mov rcx, rdi
    call free

free_lm_next:
    inc r12
    jmp free_lm_data

free_lm_array:
    mov rcx, [r15]                      ; rcx = matrix_data array
    call free
    mov rcx, r15                        ; rcx = leading_minors struct
    call free

    mov rax, 1                          ; return true
    jmp cleanup

; ========== error handlers ==========
null_ptr:
    lea rcx, [rel invalid_param]
    call puts
    xor eax, eax                        ; return false
    jmp cleanup

not_a_square:
    lea rcx, [rel not_square]
    call puts
    xor eax, eax
    jmp cleanup

wrong_leading_minors:
    lea rcx, [rel wrong_lm]
    call puts
    xor eax, eax
    jmp cleanup

check_lm_fail:
    lea rcx, [rel cant_lu]
    call puts
    ; fall through to free leading_minors

free_lm_and_fail:
    xor rcx, rcx

free_lm_fail_data:
    cmp rcx, [r15 + 8]                  ; i < leading_minors->len?
    jae free_lm_fail_array

    mov rax, rcx
    imul rax, 24
    mov rdi, [r15]                      ; rdi = leading_minors->matrix_data
    mov rdi, [rdi + rax]                ; rdi = matrix_data[i].data
    test rdi, rdi
    jz free_lm_fail_next
    mov rcx, rdi
    call free

free_lm_fail_next:
    inc rcx
    jmp free_lm_fail_data

free_lm_fail_array:
    mov rcx, [r15]
    call free
    mov rcx, r15
    call free
    xor eax, eax                        ; return false
    jmp cleanup

malloc_fail_L:
    lea rcx, [rel malloc_failed]
    call puts
    jmp free_lm_and_fail

malloc_fail_Ldata:
    lea rcx, [rel malloc_failed]
    call puts
    mov rcx, r12
    call free                           ; free L struct
    jmp free_lm_and_fail

malloc_fail_U:
    lea rcx, [rel malloc_failed]
    call puts
    mov rcx, [r12]
    call free                           ; free L->data
    mov rcx, r12
    call free                           ; free L struct
    jmp free_lm_and_fail

malloc_fail_Udata:
    lea rcx, [rel malloc_failed]
    call puts
    mov rcx, [r12]
    call free                           ; free L->data
    mov rcx, r12
    call free                           ; free L struct
    mov rcx, r13
    call free                           ; free U struct
    jmp free_lm_and_fail

malloc_fail_res:
    lea rcx, [rel malloc_failed]
    call puts
    mov rcx, [r12]
    call free                           ; free L->data
    mov rcx, r12
    call free                           ; free L struct
    mov rcx, [r13]
    call free                           ; free U->data
    mov rcx, r13
    call free                           ; free U struct
    jmp free_lm_and_fail

cleanup:
    add rsp, 32                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret
