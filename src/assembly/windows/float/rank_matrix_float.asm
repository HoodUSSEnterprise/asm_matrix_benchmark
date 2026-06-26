; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 18:52:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:22:01
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\float\rank_matrix_float.asm
; @Description: rank matrix float nasm code on windows
; -------------------------------------------------------------

global rank_matrix_float
extern puts
extern malloc
extern free

section .rodata
    epsilon        dd  1e-6
    abs_mask       dd  0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF
    malloc_failed  db  "Memory allocation failed", 0                     ; malloc failed msg
    invalid_param  db  "Invalid param!", 0                               ; invalid param msg

section .text

; bool rank_matrix_float(MatrixFloat *m, int *rank)
; rcx = m, rdx = rank

rank_matrix_float:

    ; save callee_register
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14, rcx                        ; r14 = m
    mov r15, rdx                        ; r15 = rank

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rcx]                      ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    ; check dimension
    mov r8, [r14 + 8]                   ; m->rows
    mov r9, [r14 + 16]                  ; m->cols

    cmp r8, 0                           ; m->rows == 0
    je null_ptr
    cmp r9, 0                           ; m->cols == 0
    je null_ptr

    ; malloc new data as float copy (no conversion needed, data is already float)
    mov rdi, [r14 + 16]                 ; rdi = m->cols
    imul rdi, [r14 + 8]                 ; rdi *= m->rows
    mov rcx, rdi                        ; rcx = len of array
    shl rcx, 2                          ; rcx *= 4 (sizeof float)
    call malloc
    test rax, rax
    jz malloc_fail_data

    ; save malloc res data
    mov rbx, rax                        ; rbx = data
    mov r12, [r14]                      ; r12 = m->data

    xor rdx, rdx                        ; i = 0

loop_copy:
    cmp rdx, rdi                        ; i < m->rows * m->cols
    jge next

    movss xmm0, [r12 + rdx * 4]         ; xmm0 = m->data[i] (already float)
    movss [rbx + rdx * 4], xmm0         ; data[i] = m->data[i]

    inc rdx                             ; i++
    jmp loop_copy

next:
    ; this part is gauss elimination
    mov r12, rbx                        ; r12 = new data
    mov r8, [r14 + 8]                   ; r8 = m->rows
    mov r9, [r14 + 16]                  ; r9 = m->cols
    xor rcx, rcx                        ; rows = 0
    xor rdx, rdx                        ; cols = 0
    movss xmm2, [rel epsilon]           ; xmm2 = 1e-6f
    movd xmm3, [rel abs_mask]           ; xmm3 = abs mask

loop1:
    cmp rcx, r8                         ; rows < m->rows
    jge calc_rank

    cmp rdx, r9
    jge calc_rank

    ; find main element
    mov r11, rcx                        ; r11 = pivot

    find_pivot:
        cmp r11, r8                     ; r11 < m->rows
        jge col_zero

        ; calculate offset: data[pivot * m->cols + cols]
        mov rax, r11                    ; rax = pivot
        imul rax, r9                    ; rax = pivot * m->cols
        add rax, rdx                    ; rax = pivot * m->cols + cols

        ; load value and take absolute value
        movss xmm0, [r12 + rax * 4]     ; xmm0 = data[pivot * cols + cols]
        ; fabs: clear sign bit
        andps xmm0, xmm3                ; xmm0 = fabs(value)

        ; compare fabs(value) < 1e-6
        comiss xmm0, xmm2
        jb pivot_zero                   ; if fabs(value) < epsilon, try next row

        ; found non-zero pivot
        jmp pivot_found

    pivot_zero:
        inc r11                         ; pivot++
        jmp find_pivot

    col_zero:
        inc rdx                         ; cols++
        jmp loop1

    pivot_found:
        ; check if row swap needed
        cmp r11, rcx                    ; pivot != rows?
        je no_swap

        ; swap rows: pivot <-> rows
        xor r13, r13                    ; j = 0

    swap_loop:
        cmp r13, r9                     ; j < m->cols?
        jge no_swap

        ; calculate offsets
        mov rax, r11                    ; rax = pivot
        imul rax, r9                    ; rax = pivot * m->cols
        add rax, r13                    ; rax = pivot * m->cols + j
        shl rax, 2                      ; byte offset

        mov rbx, rcx                    ; rbx = rows
        imul rbx, r9                    ; rbx = rows * m->cols
        add rbx, r13                    ; rbx = rows * m->cols + j
        shl rbx, 2                      ; byte offset

        ; swap data[pivot][j] and data[rows][j]
        movss xmm0, [r12 + rax]         ; temp = data[pivot][j]
        movss xmm1, [r12 + rbx]         ; xmm1 = data[rows][j]
        movss [r12 + rax], xmm1         ; data[pivot][j] = data[rows][j]
        movss [r12 + rbx], xmm0         ; data[rows][j] = temp

        inc r13
        jmp swap_loop

    no_swap:
        ; elimination below pivot row
        mov r13, rcx                    ; r13 = rows
        inc r13                         ; r13 = i = rows + 1

    elim_outer:
        cmp r13, r8                     ; i < rows?
        jge elim_done

        ; calculate factor = data[i][cols] / data[rows][cols]
        ; offset for data[rows][cols]
        mov rax, rcx                    ; rax = rows
        imul rax, r9                    ; rax = rows * m->cols
        add rax, rdx                    ; rax = rows * m->cols + cols
        shl rax, 2                      ; byte offset
        movss xmm0, [r12 + rax]         ; xmm0 = data[rows][cols]

        ; offset for data[i][cols]
        mov rbx, r13                    ; rbx = i
        imul rbx, r9                    ; rbx = i * m->cols
        add rbx, rdx                    ; rbx = i * m->cols + cols
        shl rbx, 2                      ; byte offset
        movss xmm1, [r12 + rbx]         ; xmm1 = data[i][cols]

        divss xmm1, xmm0                ; xmm1 = factor

        ; inner loop: j = cols to m->cols-1
        mov r10, rdx                    ; r10 = j = cols

        elim_inner:
            cmp r10, r9                 ; j < m->cols?
            jge elim_inner_done

            ; data[i][j] -= factor * data[rows][j]
            ; offset for data[rows][j]
            mov rax, rcx                ; rax = rows
            imul rax, r9                ; rax = rows * m->cols
            add rax, r10                ; rax = rows * m->cols + j
            shl rax, 2                  ; byte offset
            movss xmm2, [r12 + rax]     ; xmm2 = data[rows][j]
            mulss xmm2, xmm1            ; xmm2 = factor * data[rows][j]

            ; offset for data[i][j]
            mov rbx, r13                ; rbx = i
            imul rbx, r9                ; rbx = i * m->cols
            add rbx, r10                ; rbx = i * m->cols + j
            shl rbx, 2                  ; byte offset
            movss xmm3, [r12 + rbx]     ; xmm3 = data[i][j]
            subss xmm3, xmm2            ; xmm3 = data[i][j] - factor * data[rows][j]
            movss [r12 + rbx], xmm3     ; store result

            inc r10                     ; j++
            jmp elim_inner

    elim_inner_done:
        inc r13                         ; i++
        jmp elim_outer

elim_done:
    inc rcx                             ; rows++
    inc rdx                             ; cols++
    jmp loop1

calc_rank:

    xor rcx, rcx                        ; i = 0
    xor esi, esi                        ; calc non zero lines
    movss xmm2, [rel epsilon]
    movd xmm3, [rel abs_mask]

loop_calc_rank1:
    cmp rcx, r8                         ; i < m->rows ?
    jge end
    xor rdx, rdx                        ; j = 0

    loop_calc_rank2:
        cmp rdx, r9                     ; j < m->cols
        jge inc_rcx_calc_rank

        mov rax, rcx                    ; rax = i
        imul rax, r9                    ; rax *= m->cols
        add rax, rdx                    ; rax += j

        ; load value and take absolute value
        movss xmm0, [r12 + rax * 4]     ; xmm0 = data[i * m->cols + j]
        andps xmm0, xmm3                ; xmm0 = fabs(value)

        ; compare fabs(value) < 1e-6
        comiss xmm0, xmm2
        jnb is_not_zero                 ; if fabs(value) >= 1e-6, non-zero row
        inc rdx                         ; j++
        jmp loop_calc_rank2

    is_not_zero:
        inc esi                         ; rank++
        inc rcx                         ; i++
        jmp loop_calc_rank1

inc_rcx_calc_rank:
    inc rcx                             ; i++
    jmp loop_calc_rank1

null_ptr:
    lea rcx, [rel invalid_param]        ; rcx = invalid_param
    call puts
    mov rax, 0                          ; return false
    jmp cleanup

malloc_fail_data:
    lea rcx, [rel malloc_failed]        ; rcx = malloc_failed
    call puts
    mov rax, 0                          ; return false
    jmp cleanup

end:
    mov rcx, r12                        ; free new data
    call free
    mov dword[r15], esi
    mov rax, 1                          ; return true
    jmp cleanup

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
