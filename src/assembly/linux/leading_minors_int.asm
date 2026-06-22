;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-21 23:09:02
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-21 23:11:00
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\leading_minors_int.asm
; @Description:get leading principal minor nasm code on linux 
;-------------------------------------------------------------

global get_leading_minors_int
extern printf
extern puts
extern malloc
extern free

section .rodata
    malloc_failed db "Memory allocation failed", 0
    invalid_param db "Invalid param!", 0
    not_square    db "It's not a square", 0

section .text

; Leading_Minors_Int *get_leading_minors_int(MatrixInt *m);
; rdi = m (System V)
get_leading_minors_int:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32 ; allocate shadow space

    mov r14, rdi ; r14 = m

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rdi] ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rdi

    ; check dimension
    mov r8, [r14 + 8]   ; r8 = m->rows
    mov r9, [r14 + 16]  ; r9 = m->cols

    cmp r8, 0 ; m->rows == 0?
    je null_ptr
    cmp r9, 0 ; m->cols == 0?
    je null_ptr

    ; check square
    cmp r8, r9 ; m->rows == m->cols?
    jne not_square

    ; ========== allocate res (Leading_Minors_Int) ==========
    mov rdi, 16 ; sizeof(Leading_Minors_Int)
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov r15, rax ; r15 = res
    mov [r15 + 8], r8 ; res->len = m->rows

    ; ========== allocate matrix_data array ==========
    ; m->rows * sizeof(MatrixInt) = m->rows * 24
    mov rdi, r8
    imul rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_matrix_data

    mov [r15], rax   ; res->matrix_data = new malloc array
    mov r12, rax     ; r12 = res->matrix_data

    ; ========== init m->data pointer ==========
    mov r13, [r14]   ; r13 = m->data
    mov r8, [r14 + 8]   ; r8 = m->rows (reload after malloc call)
    mov r9, [r14 + 16]  ; r9 = m->cols (reload after malloc call)

    ; ========== loop order = 1..m->rows ==========
    mov qword [rsp + 24], 0 ; [rsp+24] = successful_count
    mov rbx, 1 ; rbx = order (1-indexed)

order_loop:
    cmp rbx, r8 ; order <= m->rows?
    ja all_done

    ; idx = order - 1
    lea r10, [rbx - 1] ; r10 = idx (0-indexed)

    ; matrix_data[idx].rows = order
    ; matrix_data[idx].cols = order
    mov rax, r10
    imul rax, 24
    lea r11, [r12 + rax] ; r11 = &matrix_data[idx]

    mov [r11 + 8], rbx ; matrix_data[idx].rows = order
    mov [r11 + 16], rbx ; matrix_data[idx].cols = order

    ; allocate matrix_data[idx].data (order * order * 4)
    mov rdi, rbx
    imul rdi, rbx ; rdi = order * order
    shl rdi, 2    ; rdi *= 4
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_subdata

    ; store data pointer immediately
    mov [r11], rax ; matrix_data[idx].data = new malloc data

    ; update successful_count
    mov qword [rsp + 24], rbx ; successful_count = order

    ; copy sub-matrix: for i=0..order-1, j=0..order-1
    ; matrix_data[idx].data[i * order + j] = m->data[i * m->cols + j]
    xor rcx, rcx ; i = 0

copy_loop_i:
    cmp rcx, rbx ; i < order?
    jge copy_done

    xor rsi, rsi ; j = 0

copy_loop_j:
    cmp rsi, rbx ; j < order?
    jge copy_inc_i

    ; src: m->data[i * m->cols + j]
    mov rax, rcx   ; rax = i
    imul rax, r9   ; rax = i * m->cols
    add rax, rsi   ; rax = i * m->cols + j
    mov edi, [r13 + rax * 4] ; edi = m->data[i * m->cols + j]

    ; dst: matrix_data[idx].data[i * order + j]
    mov rax, rcx   ; rax = i
    imul rax, rbx  ; rax = i * order
    add rax, rsi   ; rax = i * order + j

    mov rdx, [r11] ; rdx = matrix_data[idx].data
    mov [rdx + rax * 4], edi

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
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_matrix_data:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, r15
    call free wrt ..plt ; free res struct
    mov rax, 0
    jmp cleanup

malloc_fail_subdata:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    ; [rsp+24] = successful_count (number of sub-matrices with valid data)
    ; free matrix_data[0].data through matrix_data[successful_count-1].data
    xor rcx, rcx ; i = 0

free_subdata_loop:
    cmp rcx, [rsp + 24] ; i < successful_count?
    jae free_subdata_done

    mov rax, rcx
    imul rax, 24 ; rax = i * 24
    mov rdi, [r12 + rax] ; rdi = matrix_data[i].data
    test rdi, rdi
    jz free_subdata_next
    call free wrt ..plt

free_subdata_next:
    inc rcx
    jmp free_subdata_loop

free_subdata_done:
    mov rdi, r12
    call free wrt ..plt ; free matrix_data array
    mov rdi, r15
    call free wrt ..plt ; free res struct
    mov rax, 0 ; return NULL
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

not_square:
    lea rdi, [rel not_square]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

cleanup:
    add rsp, 32 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
