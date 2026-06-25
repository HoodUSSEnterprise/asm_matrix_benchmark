;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-20 16:10:25
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-20 16:16:05
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\compare_matrix_int.asm
; @Description: compare two matrix int nasm code on linux
;-------------------------------------------------------------

global is_equal_matrix_int

extern printf
extern puts

section .rodata
    invalid_param db "Invalid param!", 10, 0                                   ; invalid param msg
    dim_mismatch  db "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0       ; dim mismatch msg

section .text

; bool is_equal_matrix_int(MatrixInt *m1, MatrixInt *m2)
; rdi = m1, rsi = m2 (System V)
is_equal_matrix_int:

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

    mov r12d, [r10 + rdi * 4] ; r12d = m1->data[i]
    cmp r12d, [r11 + rdi * 4] ; m1->data[i] == m2->data[i]
    jne false_end 

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
    sub rsp, 8
    call printf wrt ..plt
    add rsp, 8
    mov rax, 0 ; return NULL
    jmp cleanup

dimension_mismatch:
    lea rdi, [rel dim_mismatch]
    mov rsi, [r14 + 8]          ; m1.rows
    mov rdx, [r14 + 16]         ; m1.cols
    mov rcx, [r15 + 8]          ; m2.rows
    mov r8,  [r15 + 16]         ; m2.cols
    xor eax, eax
    sub rsp, 8
    call printf wrt ..plt
    add rsp, 8
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
