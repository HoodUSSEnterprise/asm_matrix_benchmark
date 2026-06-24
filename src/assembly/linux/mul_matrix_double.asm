;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:31:54
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:32:34
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\mul_matrix_double.asm
; @Description:  mul matrix double nasm code on linux
;-------------------------------------------------------------

global mul_matrix_double
extern printf
extern malloc
extern free

section .rodata
    malloc_failed db "Memory allocation failed", 10, 0                         ; malloc failed msg
    invalid_param db "Invalid param!", 10, 0                                   ; invalid param msg
    dim_mismatch  db "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0       ; dim mismatch msg

section .text

; MatrixDouble *mul_matrix_double(MatrixDouble *m1, MatrixDouble *m2);
; rdi = m1, rsi = m2 (System V)
mul_matrix_double:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32 ; allocate shadow space for printf

    mov r14, rdi ; r14 = m1
    mov r15, rsi ; r15 = m2

    ; check param m1 and m2
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    mov r14, [rdi] ; r14 = m1->data
    mov r15, [rsi] ; r15 = m2->data

    ; check m1->data and m2->data
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    ; restore r14 and r15
    mov r14, rdi
    mov r15, rsi

    ; check dimension
    mov r8, [r14 + 8]   ; m1->rows
    mov r9, [r14 + 16]  ; m1->cols
    mov r10, [r15 + 8]  ; m2->rows
    mov r11, [r15 + 16] ; m2->cols

    cmp r9, r10 ; m1->cols == m2->rows
    jne dimension_mismatch

    ; save the data len
    mov rdi, r8     ; rdi = m1->rows
    imul rdi, r11    ; rdi = m1->rows * m2->cols
    mov r12, rdi    ; preserve count across malloc calls

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rdi, r12
    shl rdi, 3 ; rdi *= 8
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax      ; res->data = new malloc data
    mov r9, [r14 + 8]  ; r9 = m1->rows
    mov r10, [r15 + 16]  ; r10 = m2->cols
    mov [rbx + 8], r9   ; res->rows = m1->rows
    mov [rbx + 16], r10 ; res->cols = m2->cols

    ; init loop condition
    xor rdi, rdi ; i = 0
    xor rsi, rsi ; j = 0
    xor r13, r13 ; k = 0
    mov rdx, [r14 + 16] ; rdx = m1->cols
    mov rcx, [r15 + 16] ; rcx = m2->cols
    mov r11, [rbx]

    ; after this we don't use r14 and r15, so we use r14 and r15 directly
    mov r14, [r14]
    mov r15, [r15]

loop1:
    cmp rdi, r9 ; i < result.rows
    jge end
    xor rsi, rsi
    loop2:
        cmp rsi, r10 ; j < result.cols
        jge inc_rdi
        xorpd xmm0, xmm0 ; sum = 0.0
        xor r13, r13 ; k = 0
        loop3:
            cmp r13, rdx ; k < m1->cols
            jge give_value

            ; calc first number
            mov r8, rdi ; r8 = i
            imul r8, rdx ; r8 *= m1->cols
            add r8, r13 ; r8 += k
            movsd xmm1, [r14 + r8 * 8] ; xmm1 = m1->data[i * m1->cols + k]

            ; calc second number
            mov r8, r13 ; r8 = k
            imul r8, rcx ; r8 *= m2->cols
            add r8, rsi ; r8 += j
            mulsd xmm1, [r15 + r8 * 8] ; xmm1 *= m2->data[k * m2->cols + j]

            ; calc the sum
            addsd xmm0, xmm1
            inc r13 ; k++
            jmp loop3

    give_value:
        ; calc index
        mov r8, rdi ; r8 = i
        imul r8, r10 ; r8 *= res->cols
        add r8, rsi ; r8 += j
        movsd [r11 + r8 * 8], xmm0 ; res->data[i * res->cols + j] = sum
        inc rsi ; j++
        jmp loop2

inc_rdi:
    inc rdi ; i++
    jmp loop1

malloc_fail_struct:
    lea rdi, [rel malloc_failed] ; rdi = malloc_failed
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rdi, [rel malloc_failed] ; rdi = malloc_failed
    xor eax, eax
    call printf wrt ..plt
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param] ; rdi = invalid_param
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0 ; return NULL
    jmp cleanup

dimension_mismatch:
    lea rdi, [rel dim_mismatch]
    mov rsi, [r14 + 8]          ; m1.rows
    mov rdx, [r14 + 16]         ; m1.cols
    mov rcx, [r15 + 8]          ; m2.rows
    mov r8, [r15 + 16]          ; m2.cols
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0                  ; return NULL
    jmp cleanup

end:
    mov rax, rbx

cleanup:
    add rsp, 32 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
