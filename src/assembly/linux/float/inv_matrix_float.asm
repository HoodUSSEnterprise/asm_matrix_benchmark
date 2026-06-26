; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:46:01
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:17:30
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\float\inv_matrix_float.asm
; @Description: invertible matrix float nasm code on linux
; -------------------------------------------------------------

global inv_matrix_float
extern printf
extern puts
extern malloc
extern free
extern rank_matrix_float

section .rodata
    epsilon         dd  1e-6
    abs_mask        dd  0x7FFFFFFF
    one_float       dd  1.0
    zero_float      dd  0.0
    malloc_failed   db  "Memory allocation failed", 0
    invalid_param   db  "Invalid param!", 0
    not_square      db  "It's not a square", 0
    not_invertible  db  "It not invertible matrix", 0

section .text

; MatrixFloat *inv_matrix_float(MatrixFloat *m);
; rdi = m (System V)

inv_matrix_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi

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

    ; check rank (must be full rank)
    lea rsi, [rsp + 24]
    mov rdi, r14
    call rank_matrix_float wrt ..plt
    test rax, rax
    jz rank_fail

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    mov eax, [rsp + 24]
    cmp rax, r8
    jne not_invertible_matrix

    ; ========== allocate res (MatrixFloat) ==========
    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    mov rax, r8
    imul rax, r9
    mov r12, rax
    shl rax, 2
    mov rdi, rax
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_resdata

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    mov [rbx], rax
    mov [rbx + 8], r8
    mov [rbx + 16], r9

    ; ========== allocate aug_matrix (MatrixFloat) ==========
    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_aug

    mov r15, rax

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    mov [r15 + 8], r8
    mov r10, r9
    add r10, r9
    mov [r15 + 16], r10

    mov rax, r8
    imul rax, r10
    mov r13, rax
    shl rax, 2
    mov rdi, rax
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_augdata

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    mov [r15], rax

    mov r10, r9
    add r10, r9

    ; ========== init aug_matrix ==========
    mov r11, [r15]
    mov r12, [r14]

    xor rcx, rcx
    movss xmm1, [rel one_float]
    movss xmm0, [rel zero_float]

init_loop_i:
    cmp rcx, r8
    jge init_done

    xor rdx, rdx

    init_loop_j:
        cmp rdx, r10
        jge init_inc_i

        mov rax, rcx
        imul rax, r10
        add rax, rdx

        cmp rdx, r9
        jae init_identity

        mov rsi, rcx
        imul rsi, r9
        add rsi, rdx
        movss xmm2, [r12 + rsi * 4]
        movss [r11 + rax * 4], xmm2
        jmp init_inc_j

    init_identity:
        mov rsi, rdx
        sub rsi, rcx
        cmp rsi, r9
        je set_one
        movss [r11 + rax * 4], xmm0
        jmp init_inc_j

    set_one:
        movss [r11 + rax * 4], xmm1

    init_inc_j:
        inc rdx
        jmp init_loop_j

init_inc_i:
    inc rcx
    jmp init_loop_i

init_done:

    ; ========== Gauss-Jordan Elimination ==========
    xor rcx, rcx
    xor rdx, rdx
    movss xmm2, [rel epsilon]

gauss_loop:
    cmp rcx, r8
    jge extract_res
    cmp rdx, r10
    jge extract_res

    movd xmm3, [rel abs_mask]           ; reload abs_mask each iteration

    mov rdi, rcx

    find_pivot:
        cmp rdi, r8
        jge col_zero

        mov rax, rdi
        imul rax, r10
        add rax, rdx
        movss xmm0, [r11 + rax * 4]

        andps xmm0, xmm3

        comiss xmm0, xmm2
        jb pivot_zero

        jmp pivot_found

    pivot_zero:
        inc rdi
        jmp find_pivot

    col_zero:
        inc rdx
        jmp gauss_loop

    pivot_found:
        cmp rdi, rcx
        je normalize

        xor rsi, rsi

    swap_loop:
        cmp rsi, r10
        jge normalize

        mov rax, rdi
        imul rax, r10
        add rax, rsi
        shl rax, 2

        mov r13, rcx
        imul r13, r10
        add r13, rsi
        shl r13, 2

        movss xmm0, [r11 + rax]
        movss xmm1, [r11 + r13]
        movss [r11 + rax], xmm1
        movss [r11 + r13], xmm0

        inc rsi
        jmp swap_loop

    normalize:
        mov rax, rcx
        imul rax, r10
        add rax, rdx
        movss xmm3, [r11 + rax * 4]

        mov rsi, rdx

    norm_loop:
        cmp rsi, r10
        jge eliminate

        mov rax, rcx
        imul rax, r10
        add rax, rsi
        movss xmm0, [r11 + rax * 4]
        divss xmm0, xmm3
        movss [r11 + rax * 4], xmm0

        inc rsi
        jmp norm_loop

    eliminate:
        xor rsi, rsi

    elim_loop_i:
        cmp rsi, r8
        jge elim_done

        cmp rsi, rcx
        je elim_inc_i

        mov rax, rsi
        imul rax, r10
        add rax, rdx
        movss xmm4, [r11 + rax * 4]

        mov r13, rdx

        elim_loop_j:
            cmp r13, r10
            jge elim_inc_i

            mov rax, rcx
            imul rax, r10
            add rax, r13
            movss xmm0, [r11 + rax * 4]
            mulss xmm0, xmm4

            mov rax, rsi
            imul rax, r10
            add rax, r13
            movss xmm1, [r11 + rax * 4]
            subss xmm1, xmm0
            movss [r11 + rax * 4], xmm1

            inc r13
            jmp elim_loop_j

    elim_inc_i:
        inc rsi
        jmp elim_loop_i

elim_done:
    inc rcx
    inc rdx
    jmp gauss_loop

extract_res:
    mov rdi, [rbx]

    xor rcx, rcx

extract_i:
    cmp rcx, r8
    jge free_aug

    xor rdx, rdx

    extract_j:
        cmp rdx, r9
        jge extract_inc_i

        mov rax, rcx
        imul rax, r10
        add rax, r9
        add rax, rdx
        movss xmm0, [r11 + rax * 4]

        mov rsi, rcx
        imul rsi, r9
        add rsi, rdx
        movss [rdi + rsi * 4], xmm0

        inc rdx
        jmp extract_j

extract_inc_i:
    inc rcx
    jmp extract_i

free_aug:
    mov rdi, [r15]
    call free wrt ..plt
    mov rdi, r15
    call free wrt ..plt

    mov rax, rbx
    jmp cleanup

malloc_fail_struct:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_resdata:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_aug:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, [rbx]
    call free wrt ..plt
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_augdata:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, [rbx]
    call free wrt ..plt
    mov rdi, rbx
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

not_invertible_matrix:
    lea rdi, [rel not_invertible]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

rank_fail:
    mov rax, 0
    jmp cleanup

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
