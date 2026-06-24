;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:43:49
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:44:19
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\rank_matrix_float.asm
; @Description: rank matrix float nasm code on linux
;-------------------------------------------------------------

global rank_matrix_float
extern puts
extern malloc
extern free

section .rodata
    epsilon dd 1e-6
    abs_mask dd 0x7FFFFFFF
    malloc_failed db "Memory allocation failed", 0
    invalid_param db "Invalid param!", 0

section .text

; bool rank_matrix_float(MatrixFloat *m, int *rank)
; rdi = m, rsi = rank (System V)
rank_matrix_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi
    mov r15, rsi

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

    mov rdi, [r14 + 16]
    imul rdi, [r14 + 8]
    mov r12, rdi        ; preserve element count
    shl rdi, 2          ; rdi = byte size
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov rbx, rax
    mov r13, [r14]

    xor rdx, rdx
    mov rdi, r12        ; restore element count

loop_copy:
    cmp rdx, rdi
    jge next

    movss xmm0, [r13 + rdx * 4]
    movss [rbx + rdx * 4], xmm0

    inc rdx
    jmp loop_copy

next:
    mov r12, rbx
    mov r8, [r14 + 8]
    mov r9, [r14 + 16]
    xor rcx, rcx
    xor rdx, rdx
    movss xmm2, [rel epsilon]

loop1:
    cmp rcx, r8
    jge calc_rank

    cmp rdx, r9
    jge calc_rank

    movd xmm3, [rel abs_mask]   ; reload abs_mask for each outer iteration
    mov r11, rcx
    find_pivot:
        cmp r11, r8
        jge col_zero

        mov rax, r11
        imul rax, r9
        add rax, rdx

        movss xmm0, [r12 + rax * 4]
        andps xmm0, xmm3

        comiss xmm0, xmm2
        jb pivot_zero

        jmp pivot_found

    pivot_zero:
        inc r11
        jmp find_pivot

    col_zero:
        inc rdx
        jmp loop1

    pivot_found:
        cmp r11, rcx
        je no_swap

        xor r13, r13

    swap_loop:
        cmp r13, r9
        jge no_swap

        mov rax, r11
        imul rax, r9
        add rax, r13
        shl rax, 2

        mov rbx, rcx
        imul rbx, r9
        add rbx, r13
        shl rbx, 2

        movss xmm0, [r12 + rax]
        movss xmm1, [r12 + rbx]
        movss [r12 + rax], xmm1
        movss [r12 + rbx], xmm0

        inc r13
        jmp swap_loop

    no_swap:
        mov r13, rcx
        inc r13

    elim_outer:
        cmp r13, r8
        jge elim_done

        mov rax, rcx
        imul rax, r9
        add rax, rdx
        shl rax, 2
        movss xmm0, [r12 + rax]

        mov rbx, r13
        imul rbx, r9
        add rbx, rdx
        shl rbx, 2
        movss xmm1, [r12 + rbx]

        divss xmm1, xmm0

        mov r10, rdx

        elim_inner:
            cmp r10, r9
            jge elim_inner_done

            mov rax, rcx
            imul rax, r9
            add rax, r10
            shl rax, 2
            movss xmm2, [r12 + rax]
            mulss xmm2, xmm1

            mov rbx, r13
            imul rbx, r9
            add rbx, r10
            shl rbx, 2
            movss xmm3, [r12 + rbx]
            subss xmm3, xmm2
            movss [r12 + rbx], xmm3

            inc r10
            jmp elim_inner

    elim_inner_done:
        inc r13
        jmp elim_outer

elim_done:
    inc rcx
    inc rdx
    jmp loop1

calc_rank:

    xor rcx, rcx
    xor esi, esi
    movss xmm2, [rel epsilon]
    movd xmm3, [rel abs_mask]

loop_calc_rank1:
    cmp rcx, r8
    jge end
    xor rdx, rdx
    loop_calc_rank2:
        cmp rdx, r9
        jge inc_rcx_calc_rank

        mov rax, rcx
        imul rax, r9
        add rax, rdx

        movss xmm0, [r12 + rax * 4]
        andps xmm0, xmm3

        comiss xmm0, xmm2
        jnb is_not_zero
        inc rdx
        jmp loop_calc_rank2

    is_not_zero:
        inc esi
        inc rcx
        jmp loop_calc_rank1

inc_rcx_calc_rank:
    inc rcx
    jmp loop_calc_rank1


null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

end:
    mov rdi, r12
    call free wrt ..plt
    mov dword [r15], esi
    mov rax, 1
    jmp cleanup

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
