;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-21 23:10:11
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-21 23:10:42
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\inv_matrix_int.asm
; @Description:invertible matrix int nasm code on linux 
;-------------------------------------------------------------

global inv_matrix_int
extern printf
extern puts
extern malloc
extern free
extern rank_matrix_int

section .rodata
    epsilon          dq 1e-6
    malloc_failed    db "Memory allocation failed", 0
    invalid_param    db "Invalid param!", 0
    not_square       db "It's not a square", 0
    not_invertible   db "It not invertible matrix", 0

section .text

; MatrixDouble *inv_matrix_int(MatrixInt *m);
; rdi = m (System V)
inv_matrix_int:

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

    ; check dimension (square matrix)
    mov r8, [r14 + 8]   ; r8 = m->rows
    mov r9, [r14 + 16]  ; r9 = m->cols

    cmp r8, r9 ; m->rows == m->cols
    jne not_square

    ; check rank (must be full rank)
    lea rsi, [rsp + 24] ; rsi = &rank (local var)
    mov rdi, r14        ; rdi = m
    call rank_matrix_int wrt ..plt
    test rax, rax        ; check return value (bool)
    jz rank_fail

    ; reload r8, r9 after call (scratch registers clobbered)
    mov r8, [r14 + 8]   ; r8 = m->rows
    mov r9, [r14 + 16]  ; r9 = m->cols

    mov rax, [rsp + 24] ; rax = rank
    cmp rax, r8         ; rank == m->rows?
    jne not_invertible

    ; ========== allocate res (MatrixDouble) ==========
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax ; rbx = res

    ; reload r8, r9 after malloc call
    mov r8, [r14 + 8]   ; r8 = m->rows
    mov r9, [r14 + 16]  ; r9 = m->cols

    ; allocate res->data (rows * cols * 8)
    mov rax, r8         ; rax = m->rows
    imul rax, r9        ; rax = m->rows * m->cols
    mov r12, rax        ; r12 = element count (callee-saved)
    shl rax, 3          ; rax *= 8 (sizeof double)
    mov rdi, rax
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_resdata

    ; reload r8, r9 after malloc call
    mov r8, [r14 + 8]   ; r8 = m->rows
    mov r9, [r14 + 16]  ; r9 = m->cols

    mov [rbx], rax      ; res->data = new malloc data
    mov [rbx + 8], r8   ; res->rows = m->rows
    mov [rbx + 16], r9  ; res->cols = m->cols

    ; ========== allocate aug_matrix (MatrixDouble) ==========
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_aug

    mov r15, rax ; r15 = aug_matrix

    ; reload r8, r9 after malloc call
    mov r8, [r14 + 8]   ; r8 = m->rows
    mov r9, [r14 + 16]  ; r9 = m->cols

    ; aug_matrix->rows = m->rows
    ; aug_matrix->cols = m->cols * 2
    mov [r15 + 8], r8   ; aug_matrix->rows = m->rows
    lea r10, [r9 * 2]   ; r10 = m->cols * 2 = aug_matrix->cols
    mov [r15 + 16], r10 ; aug_matrix->cols = m->cols * 2

    ; allocate aug_matrix->data (rows * cols * 2 * 8)
    mov rax, r8         ; rax = m->rows
    imul rax, r10       ; rax = m->rows * aug_matrix->cols
    mov r13, rax        ; r13 = aug element count (callee-saved)
    shl rax, 3          ; rax *= 8
    mov rdi, rax
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_augdata

    ; reload r8, r9 after malloc call
    mov r8, [r14 + 8]   ; r8 = m->rows
    mov r9, [r14 + 16]  ; r9 = m->cols

    mov [r15], rax      ; aug_matrix->data = new malloc data

    ; r10 = aug_cols (recompute after malloc clobbered it)
    lea r10, [r9 * 2]   ; r10 = m->cols * 2 = aug_matrix->cols

    ; ========== init aug_matrix ==========
    ; Left half: m->data as double
    ; Right half: identity matrix
    mov r11, [r15]      ; r11 = aug_matrix->data (double*)
    mov r12, [r14]      ; r12 = m->data (int*)

    xor rcx, rcx ; i = 0

init_loop_i:
    cmp rcx, r8 ; i < m->rows?
    jge init_done

    xor rdx, rdx ; j = 0

init_loop_j:
    cmp rdx, r10 ; j < aug_matrix->cols?
    jge init_inc_i

    ; index = i * aug_matrix->cols + j
    mov rax, rcx       ; rax = i
    imul rax, r10      ; rax = i * aug_matrix->cols
    add rax, rdx       ; rax += j

    cmp rdx, r9        ; j < m->cols?
    jae init_identity  ; if j >= m->cols, go to right half

    ; left half: copy m->data as double
    mov rsi, rcx       ; rsi = i
    imul rsi, r9       ; rsi = i * m->cols
    add rsi, rdx       ; rsi = i * m->cols + j
    movsxd rsi, [r12 + rsi * 4] ; sign-extend int to 64-bit
    cvtsi2sd xmm0, rsi ; convert to double
    movsd [r11 + rax * 8], xmm0
    jmp init_inc_j

init_identity:
    ; right half: identity matrix
    ; identity if j - i == m->cols
    mov rsi, rdx
    sub rsi, rcx       ; rsi = j - i
    cmp rsi, r9        ; j - i == m->cols?
    sete sil
    movzx esi, sil
    cvtsi2sd xmm0, esi
    movsd [r11 + rax * 8], xmm0

init_inc_j:
    inc rdx ; j++
    jmp init_loop_j

init_inc_i:
    inc rcx ; i++
    jmp init_loop_i

init_done:

    ; ========== Gauss-Jordan Elimination ==========
    ; r11 = aug_matrix->data
    ; r8  = m->rows (= aug_rows)
    ; r10 = aug_cols (= m->cols * 2)
    ; r9  = m->cols (used later for extraction)
    ; r14 = m (preserved)
    ; r15 = aug_matrix (preserved)
    ; rbx = res (preserved)

    xor rcx, rcx ; rows = 0
    xor rdx, rdx ; cols = 0

gauss_loop:
    cmp rcx, r8  ; rows < aug_rows?
    jge extract_res
    cmp rdx, r10 ; cols < aug_cols?
    jge extract_res

    ; find pivot
    mov rdi, rcx ; rdi = pivot = rows

find_pivot:
    cmp rdi, r8      ; pivot < aug_rows?
    jge col_zero

    ; offset = pivot * aug_cols + cols
    mov rax, rdi
    imul rax, r10
    add rax, rdx
    movsd xmm0, [r11 + rax * 8]

    ; fabs: clear sign bit
    mov rsi, 0x7FFFFFFFFFFFFFFF
    movq xmm1, rsi
    andps xmm0, xmm1

    movsd xmm2, [rel epsilon]
    comisd xmm0, xmm2
    jb pivot_zero

    jmp pivot_found

pivot_zero:
    inc rdi
    jmp find_pivot

col_zero:
    inc rdx ; cols++
    jmp gauss_loop

pivot_found:
    cmp rdi, rcx ; pivot != rows?
    je normalize

    ; swap rows: pivot <-> rows
    xor rsi, rsi ; j = 0

swap_loop:
    cmp rsi, r10 ; j < aug_cols?
    jge normalize

    ; data[pivot][j] <-> data[rows][j]
    mov rax, rdi   ; rax = pivot
    imul rax, r10  ; rax = pivot * aug_cols
    add rax, rsi   ; rax = pivot * aug_cols + j
    shl rax, 3     ; byte offset

    mov r13, rcx   ; r13 = rows (use r13, not rbx, to preserve res ptr)
    imul r13, r10  ; r13 = rows * aug_cols
    add r13, rsi   ; r13 = rows * aug_cols + j
    shl r13, 3     ; byte offset

    ; swap
    movsd xmm0, [r11 + rax]
    movsd xmm1, [r11 + r13]
    movsd [r11 + rax], xmm1
    movsd [r11 + r13], xmm0

    inc rsi
    jmp swap_loop

normalize:
    ; normalize pivot row: divide by pivot_val
    ; pivot_val = data[rows * aug_cols + cols]
    mov rax, rcx
    imul rax, r10
    add rax, rdx
    movsd xmm3, [r11 + rax * 8] ; xmm3 = pivot_val

    mov rsi, rdx ; j = cols

norm_loop:
    cmp rsi, r10 ; j < aug_cols?
    jge eliminate

    ; data[rows][j] /= pivot_val
    mov rax, rcx
    imul rax, r10
    add rax, rsi
    movsd xmm0, [r11 + rax * 8]
    divsd xmm0, xmm3
    movsd [r11 + rax * 8], xmm0

    inc rsi
    jmp norm_loop

eliminate:
    xor rsi, rsi ; i = 0

elim_loop_i:
    cmp rsi, r8  ; i < aug_rows?
    jge elim_done

    cmp rsi, rcx ; i == rows? skip pivot row
    je elim_inc_i

    ; factor = data[i * aug_cols + cols] (pivot row is normalized to 1)
    mov rax, rsi
    imul rax, r10
    add rax, rdx
    movsd xmm4, [r11 + rax * 8] ; xmm4 = factor

    mov r13, rdx ; j = cols

elim_loop_j:
    cmp r13, r10 ; j < aug_cols?
    jge elim_inc_i

    ; data[i][j] -= factor * data[rows][j]
    mov rax, rcx       ; rax = rows
    imul rax, r10      ; rax = rows * aug_cols
    add rax, r13       ; rax = rows * aug_cols + j
    movsd xmm0, [r11 + rax * 8] ; xmm0 = data[rows][j]
    mulsd xmm0, xmm4  ; xmm0 = factor * data[rows][j]

    mov rax, rsi       ; rax = i
    imul rax, r10      ; rax = i * aug_cols
    add rax, r13       ; rax = i * aug_cols + j
    movsd xmm1, [r11 + rax * 8] ; xmm1 = data[i][j]
    subsd xmm1, xmm0  ; xmm1 = data[i][j] - factor * data[rows][j]
    movsd [r11 + rax * 8], xmm1

    inc r13 ; j++
    jmp elim_loop_j

elim_inc_i:
    inc rsi ; i++
    jmp elim_loop_i

elim_done:
    inc rcx ; rows++
    inc rdx ; cols++
    jmp gauss_loop

extract_res:
    ; extract right half of aug_matrix into res
    ; r8  = res->rows (= m->rows)
    ; r9  = res->cols (= m->cols)
    ; r10 = aug_cols (= m->cols * 2)
    ; r11 = aug_matrix->data
    ; rbx = res (struct)
    mov rdi, [rbx] ; rdi = res->data

    xor rcx, rcx ; i = 0

extract_i:
    cmp rcx, r8 ; i < res->rows?
    jge free_aug

    xor rdx, rdx ; j = 0

extract_j:
    cmp rdx, r9 ; j < res->cols?
    jge extract_inc_i

    ; aug index = i * aug_cols + (m->cols + j)
    mov rax, rcx
    imul rax, r10      ; i * aug_cols
    lea rax, [rax + r9] ; + m->cols
    add rax, rdx       ; + j
    movsd xmm0, [r11 + rax * 8]

    ; res index = i * res->cols + j
    mov rsi, rcx
    imul rsi, r9
    add rsi, rdx
    movsd [rdi + rsi * 8], xmm0

    inc rdx ; j++
    jmp extract_j

extract_inc_i:
    inc rcx ; i++
    jmp extract_i

free_aug:
    ; free aug_matrix->data
    mov rdi, [r15]
    call free wrt ..plt
    ; free aug_matrix struct
    mov rdi, r15
    call free wrt ..plt

    mov rax, rbx ; return res
    jmp cleanup

malloc_fail_struct:
    lea rdi, [rel malloc_failed] ; rdi = malloc_failed
    call puts wrt ..plt
    mov rax, 0 ; return NULL
    jmp cleanup

malloc_fail_resdata:
    lea rdi, [rel malloc_failed] ; rdi = malloc_failed
    call puts wrt ..plt
    mov rdi, rbx
    call free wrt ..plt ; free res struct
    mov rax, 0 ; return NULL
    jmp cleanup

malloc_fail_aug:
    lea rdi, [rel malloc_failed] ; rdi = malloc_failed
    call puts wrt ..plt
    mov rdi, [rbx]
    call free wrt ..plt ; free res->data
    mov rdi, rbx
    call free wrt ..plt ; free res struct
    mov rax, 0 ; return NULL
    jmp cleanup

malloc_fail_augdata:
    lea rdi, [rel malloc_failed] ; rdi = malloc_failed
    call puts wrt ..plt
    mov rdi, [rbx]
    call free wrt ..plt ; free res->data
    mov rdi, rbx
    call free wrt ..plt ; free res struct
    mov rdi, r15
    call free wrt ..plt ; free aug_matrix struct
    mov rax, 0 ; return NULL
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param] ; rdi = invalid_param
    call puts wrt ..plt
    mov rax, 0 ; return NULL
    jmp cleanup

not_square:
    lea rdi, [rel not_square] ; rdi = not_square
    call puts wrt ..plt
    mov rax, 0 ; return NULL
    jmp cleanup

not_invertible:
    lea rdi, [rel not_invertible] ; rdi = not invertible
    call puts wrt ..plt
    mov rax, 0 ; return NULL
    jmp cleanup

rank_fail:
    mov rax, 0 ; return NULL
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
