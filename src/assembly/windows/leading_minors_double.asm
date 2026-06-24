;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\leading_minors_double.asm
; @Description: get leading principal minor double nasm code on windows
;-------------------------------------------------------------

global get_leading_minors_double
extern printf
extern puts
extern malloc
extern free

section .rodata
    malloc_failed db "Memory allocation failed", 0
    invalid_param db "Invalid param!", 0
    not_square    db "It's not a square", 0

section .text

; Leading_Minors_Double *get_leading_minors_double(MatrixDouble *m);
; rcx = m (Windows)
get_leading_minors_double:

    ; save callee_register
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 48 ; allocate shadow space

    mov r14, rcx ; r14 = m

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rcx] ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    ; check dimension
    mov r8, [r14 + 8]   ; r8 = m->rows
    mov r9, [r14 + 16]  ; r9 = m->cols

    cmp r8, 0 ; m->rows == 0?
    je null_ptr
    cmp r9, 0 ; m->cols == 0?
    je null_ptr

    ; check square
    cmp r8, r9 ; m->rows == m->cols?
    jne not_a_square

    ; ========== allocate res (Leading_Minors_Double) ==========
    ; typedef struct Leading_Minors_Double
    ; {
    ;     MatrixDouble *matrix_data;
    ;     size_t len;
    ; } Leading_Minors_Double;
    mov rcx, 16 ; sizeof(Leading_Minors_Double)
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov r8, [r14 + 8]
    mov r15, rax ; r15 = res
    mov [r15 + 8], r8 ; res->len = m->rows

    ; ========== allocate matrix_data array ==========
    ; m->rows * sizeof(MatrixDouble) = m->rows * 24
    mov rcx, r8
    imul rcx, 24
    call malloc
    test rax, rax
    jz malloc_fail_matrix_data

    mov [r15], rax   ; res->matrix_data = new malloc array
    mov r12, rax     ; r12 = res->matrix_data, len = m->rows

    ; ========== init m->data pointer ==========
    mov r13, [r14]   ; r13 = m->data (double*)
    mov r8, [r14 + 8]   ; r8 = m->rows (reload after malloc call)
    mov r9, [r14 + 16]  ; r9 = m->cols (reload after malloc call)

    ; ========== loop order = 1..m->rows ==========

    mov rdi, 0 ; rdi = successful_count
    mov rbx, 1 ; rbx = order (1-indexed)

order_loop:
    mov r8, [r14 + 8]   ; r8 = m->rows (reload after malloc call)
    cmp rbx, r8 ; order <= m->rows?
    ja all_done

    ; idx = order - 1
    mov r10, rbx ; r10 = order (0-indexed)
    dec r10      ; r10 = idx = order - 1

    ; matrix_data[idx].rows = order
    ; matrix_data[idx].cols = order
    mov rax, r10
    imul rax, 24
    lea r11, [r12 + rax] ; r11 = res->matrix_data[idx]

    mov [r11 + 8], rbx ; matrix_data[idx].rows = order
    mov [r11 + 16], rbx ; matrix_data[idx].cols = order

    mov [rsp + 32], r11
    ; allocate matrix_data[idx].data (order * order * 8)
    mov rcx, rbx
    imul rcx, rbx ; rcx = order * order
    shl rcx, 3    ; rcx *= 8
    call malloc
    test rax, rax
    jz malloc_fail_subdata

    ; store data pointer immediately
    mov r11, [rsp + 32]
    mov [r11], rax ; matrix_data[idx].data = new malloc data

    ; update successful_count
    mov rdi, rbx ; successful_count = order

    ; copy sub-matrix: for i=0..order-1, j=0..order-1
    ; matrix_data[idx].data[i * order + j] = m->data[i * m->cols + j]
    xor rcx, rcx ; i = 0
    mov rdx, [r11] ; rdx = matrix_data[idx].data
    copy_loop_i:
        cmp rcx, rbx ; i < order?
        jge copy_done

        xor rsi, rsi ; j = 0

        copy_loop_j:
            cmp rsi, rbx ; j < order?
            jge copy_inc_i

            ; src: m->data[i * m->cols + j]
            mov rax, rcx   ; rax = i
            imul rax, [r14 + 16]   ; rax = i * m->cols
            add rax, rsi   ; rax = i * m->cols + j
            movsd xmm0, [r13 + rax * 8] ; xmm0 = m->data[i * m->cols + j]

            ; dst: matrix_data[idx].data[i * order + j]
            mov rax, rcx   ; rax = i
            imul rax, rbx  ; rax = i * order
            add rax, rsi   ; rax = i * order + j

            movsd [rdx + rax * 8], xmm0

            inc rsi ; j++
            jmp copy_loop_j

    copy_inc_i:

        inc rcx ; i++
        jmp copy_loop_i

    copy_done:

        inc rbx ; order++
        jmp order_loop

all_done:

    mov rax, r15 ; return res
    jmp cleanup

; ========== malloc failure handling ==========
malloc_fail_struct:
    lea rcx, [rel malloc_failed]
    call puts
    mov rax, 0
    jmp cleanup

malloc_fail_matrix_data:
    lea rcx, [rel malloc_failed]
    call puts
    mov rcx, r15
    call free ; free res struct
    mov rax, 0
    jmp cleanup

malloc_fail_subdata:
    lea rcx, [rel malloc_failed]
    call puts
    ; rdi = successful_count (number of sub-matrices with valid data)
    ; free matrix_data[0].data through matrix_data[successful_count-1].data
    xor rsi, rsi ; i = 0

    free_subdata_loop:
        cmp rsi, rdi ; i < successful_count?
        jae free_subdata_done

        mov rax, rsi
        imul rax, 24 ; rax = i * 24
        mov r8, [r12 + rax] ; rdi = matrix_data[i].data
        test r8, r8
        jz free_subdata_next
        mov rcx, r8
        call free

    free_subdata_next:
        inc rsi
        jmp free_subdata_loop

free_subdata_done:
    mov rcx, r12
    call free ; free matrix_data array
    mov rcx, r15
    call free ; free res struct
    mov rax, 0 ; return NULL
    jmp cleanup

null_ptr:
    lea rcx, [rel invalid_param]
    call puts
    mov rax, 0
    jmp cleanup

not_a_square:
    lea rcx, [rel not_square]
    call puts
    mov rax, 0
    jmp cleanup

cleanup:
    add rsp, 48 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret