;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:30:25
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:33:11
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\compare_matrix_double.asm
; @Description: compare two matrix double nasm code on linux
;-------------------------------------------------------------

global is_equal_matrix_double

extern printf
extern puts

section .rodata
    epsilon       dq 1e-6
    invalid_param db "Invalid param!", 10, 0                                         ; invalid param msg
    dim_mismatch  db "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0       ; dim mismatch msg

section .text

; bool is_equal_matrix_double(MatrixDouble *m1, MatrixDouble *m2)
; rdi = m1, rsi = m2 (System V)
is_equal_matrix_double:

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

    cmp r8, r10 ; m1->rows == m2->rows
    jne dimension_mismatch
    cmp r9, r11 ; m1->cols == m2->cols
    jne dimension_mismatch

    ; init loop condition
    xor rdi, rdi ; i = 0
    mov rsi, r8 ; rsi = m1->rows
    imul rsi, r9 ; rsi *= m1->cols
    mov r10, [r14] ; r10 = m1->data
    mov r11, [r15] ; r11 = m2->data

loop1:
    cmp rdi, rsi ; i < rsi
    jge true_end

    movsd xmm0, [r10 + rdi * 8] ; xmm0 = m1->data[i]
    subsd xmm0, [r11 + rdi * 8] ; xmm0 = m1->data[i] - m2->data[i]
    ; fabs: clear sign bit
    mov r13, 0x7FFFFFFFFFFFFFFF
    movq xmm1, r13
    andps xmm0, xmm1          ; xmm0 = fabs(m1->data[i] - m2->data[i])

    ; compare fabs(value) < 1e-6
    movsd xmm2, [rel epsilon]     ; xmm2 = 1e-6
    comisd xmm0, xmm2
    jae false_end               ; if fabs(value) >= epsilon, not equal

    inc rdi ; i++
    jmp loop1

true_end:
    mov rax, 1  ; return true
    jmp cleanup

false_end:
    mov rax, 0  ; return false
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
    mov r8,  [r15 + 16]         ; m2.cols
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0                  ; return NULL
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
