; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-23 23:29:14
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:20:30
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\double\cat_matrix_double.asm
; @Description: cat matrix double nasm code on windows
; -------------------------------------------------------------

global cat_matrix_double
extern malloc
extern free
extern printf
extern puts

section .rodata
    malloc_failed  db  "Memory allocation failed", 10, 0                            ; malloc failed msg
    invalid_param  db  "Invalid param!", 10, 0                                      ; invalid param msg
    dim_mismatch   db  "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0    ; dim mismatch msg
    wrong_params   db  "Wrong value, axis must be 0 or 1"

section .text

; MatrixDouble *cat_matrix_double(MatrixDouble *m1, MatrixDouble *m2, int axis);
; rcx = m1, rdx = m2, r8d = axis
; axis : 1 means horizon, 0 means vertical

cat_matrix_double:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14, rcx                        ; r14 = m1
    mov r15, rdx                        ; r15 = m2
    mov r13d, r8d                       ; r13d = axis

    ; check param m1 and m2
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    mov r14, [rcx]                      ; r14 = m1->data
    mov r15, [rdx]                      ; r15 = m2->data

    ; check m1->data and m2->data
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    ; restore r14 and r15
    mov r14, rcx
    mov r15, rdx

    cmp r13d, 0
    jne greater_than_zero

    ; axis = 0, means vertical
    ; check dimension of cols
    mov r9, [r14 + 16]                  ; m1->cols
    mov r11, [r15 + 16]                 ; m2->cols

    cmp r9, r11                         ; m1->cols == m2->cols
    jne dimension_mismatch

    ; malloc new res
    mov rcx, 24                         ; sizeof(MatrixInt) = 24
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    ; res->cols = m1->cols
    ; res->rows = m1->rows + m2->rows
    mov rdi, [r14 + 16]                 ; m1->cols
    mov r12, [r14 + 8]                  ; m1->rows
    add r12, [r15 + 8]                  ; m1->rows + m2->rows
    imul rdi, r12                       ; res->rows * res->cols
    mov rcx, rdi                        ; number of sizeof(int)
    shl rcx, 3                          ; rcx *= 8
    call malloc
    test rax, rax
    jz malloc_fail_data

    ; new res
    mov [rbx], rax                      ; res->data = data
    mov [rbx + 8], r12                  ; res->rows = m1->rows + m2->rows
    mov r8, [r14 + 16]                  ; r8 = m1->cols
    mov [rbx + 16], r8                  ; res->cols = m1->cols

    ; init loop condition
    xor rcx, rcx                        ; i = 0
    xor rdx, rdx                        ; j = 0
    mov rdi, [r14 + 16]                 ; rdi = m1->cols, is a division
    mov rsi, [rbx]
    mov r8, [r14 + 8]                   ; r8 = m1->rows
    ; we don't use r14 and r15 as param, so we use it as data
    mov r14, [r14]
    mov r15, [r15]

loop1:
    cmp rcx, r12                        ; i < res->rows
    jge end
    xor rdx, rdx

    loop2:
        cmp rdx, rdi                    ; j < res->cols
        jge loop1out1

        cmp rcx, r8                     ; i < m1->rows
        jge matrix_after1
        mov r9, rdi                     ; r9 = m1->cols
        imul r9, rcx                    ; r9 *= i
        add r9, rdx                     ; r9 += j
        movsd xmm0, [r14 + r9 * 8]      ; xmm0 = m1->data[i * res->cols + j]
        movsd [rsi + r9 * 8], xmm0
        inc rdx                         ; j++
        jmp loop2

    matrix_after1:
        mov r13, rdi                    ; r13 = res->cols
        imul r13, rcx                   ; r13 *= i
        add r13, rdx                    ; r13 += j
        mov r9, rdi                     ; r9 = res->cols
        mov r11, rcx                    ; r11 = i 
        sub r11, r8                     ; r11 = i - m1->rows
        imul r9, r11                    ; r9 = (i - m1->rows) * res->cols
        add r9, rdx                     ; r9 += j
        movsd xmm0, [r15 + r9 * 8]      ; xmm0 = m1->data[(i - m1->rows) * res->cols + j]
        movsd [rsi + r13 * 8], xmm0
        inc rdx                         ; j++
        jmp loop2

loop1out1:
    inc rcx                             ; i++
    jmp loop1

greater_than_zero:
    cmp r13, 1
    jne invalid_axis

    ; axis = 1, means horizon
    ; check dimension of rows
    mov r9, [r14 + 8]                   ; m1->rows
    mov r11, [r15 + 8]                  ; m2->rows

    cmp r9, r11                         ; m1->rows == m2->rows
    jne dimension_mismatch

    ; malloc new res
    mov rcx, 24                         ; sizeof(MatrixInt) = 24
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    ; res->rows = m1->rows
    ; res->cols = m1->cols + m2->cols
    mov rdi, [r14 + 8]                  ; m1->rows
    mov r12, [r14 + 16]                 ; m1->cols
    add r12, [r15 + 16]                 ; m1->cols + m2->cols
    imul rdi, r12                       ; res->rows * res->cols
    mov rcx, rdi                        ; number of sizeof(int)
    shl rcx, 3                          ; rcx *= 8
    call malloc
    test rax, rax
    jz malloc_fail_data

    ; new res
    mov [rbx], rax                      ; res->data = data
    mov r8, [r14 + 8]                   ; r8 = m1->rows
    mov [rbx + 8], r8                   ; res->rows = m1->rows
    mov [rbx + 16], r12                 ; res->cols = m1->cols + m2->cols

    ; init loop condition
    xor rcx, rcx                        ; i = 0
    xor rdx, rdx                        ; j = 0
    mov rdi, [r14 + 16]                 ; rdi = m1->cols, is a division
    mov r13, [r15 + 16]                 ; r13 = m2->cols
    mov rsi, [rbx]
    ; we don't use r14 and r15 as param, so we use it as data
    mov r14, [r14]
    mov r15, [r15]

loop11:
    cmp rcx, r8                         ; i < res->rows
    jge end
    xor rdx, rdx

    loop21:
        cmp rdx, r12                    ; j < res->cols
        jge loop1out11

        cmp rdx, rdi
        jge matrix_after11
        mov r9, rdi                     ; r9 = m1->cols
        imul r9, rcx                    ; r9 *= i
        add r9, rdx                     ; r9 += j
        movsd xmm0, [r14 + r9 * 8]      ; xmm0 = m1->data[i * m1->cols + j]
        mov r9, r12                     ; r9 = res->cols
        imul r9, rcx                    ; r9 *= i
        add r9, rdx                     ; r9 += j
        movsd [rsi + r9 * 8], xmm0      ; res->data[i * res->cols + j] = xmm0
        inc rdx                         ; j++
        jmp loop21

    matrix_after11:
        mov r9, r13                     ; r9 = m2->cols
        imul r9, rcx                    ; r9 *= i
        add r9, rdx                     ; r9 += j
        sub r9, rdi                     ; r9 = i * m2->cols + j - m1->cols
        movsd xmm0, [r15 + r9 * 8]      ; xmm0 = m2->data[i * m2->cols + j - m1->cols]
        mov r9, r12                     ; r9 = res->cols
        imul r9, rcx                    ; r9 *= i
        add r9, rdx                     ; r9 += j
        movsd [rsi + r9 * 8], xmm0
        inc rdx                         ; j++
        jmp loop21

loop1out11:
    inc rcx                             ; i++
    jmp loop11

invalid_axis:
    lea rcx, [rel wrong_params]         ; rcx = wrong_params
    call puts
    jmp cleanup

malloc_fail_struct:
    lea rcx, [rel malloc_failed]        ; rcx = malloc_failed
    call printf
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rcx, [rel malloc_failed]        ; rcx = malloc_failed
    call printf
    mov rcx, rbx
    call free
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rcx, [rel invalid_param]        ; rcx = invalid_param
    call printf
    mov rax, 0                          ; return NULL
    jmp cleanup

end:
    mov rax, rbx
    jmp cleanup

dimension_mismatch:
    lea rcx, [rel dim_mismatch]
    mov rdx, [r14 + 8]                  ; m1.rows
    mov r8, [r14 + 16]                  ; m1.cols
    mov r9, [r15 + 8]                   ; m2.rows
    mov r10, [r15 + 16]                 ; m2.cols
    mov [rsp + 32], r10                 ; fifth parament
    call printf
    mov rax, 0                          ; return NULL
    jmp cleanup

cleanup:
    add rsp, 32                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    ret
