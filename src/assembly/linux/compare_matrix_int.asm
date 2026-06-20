;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-19 11:10:25
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-20 10:38:19
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\compare_matrix_int.asm
; @Description: compare two matrix int nasm code on windows
;-------------------------------------------------------------
global is_equal_matrix_int

extern printf
extern puts

section .rodata
    invalid_param db "Invalid param!", 10, 0                                   ; invalid param msg
    dim_mismatch  db "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0       ; dim mismatch msg

section .text

; bool is_equal_matrix_int(MatrixInt *m1, MatrixInt *m2)
; rcx = m1, rdx = m2
is_equal_matrix_int:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32 ; allocate shadow space for printf

    mov r14, rcx ; r14 = m1
    mov r15, rdx ; r15 = m2

    ; check param m1 and m2
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    mov r14, [rcx] ; r14 = m1->data
    mov r15, [rdx] ; r15 = m2->data

    ; check m1->data and m2->data
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    ; restore r14 and r15
    mov r14, rcx
    mov r15, rdx

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

    mov r12, [r10 + rdi * 4] ; r12 = m1->data[i]
    cmp r12, [r11 + rdi * 4] ; m1->data[i] == m2->data[i]
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
    lea rcx, [rel invalid_param] ; rcx = invalid_param
    call printf
    mov rax, 0 ; return NULL
    jmp cleanup

dimension_mismatch:
    lea rcx, [rel dim_mismatch] 
    mov rdx, [r14 + 8]          ; m1.rows
    mov r8, [r14 + 16]          ; m1.cols
    mov r9, [r15 + 8]           ; m2.rows
    mov r10, [r15 + 16]         ; m2.cols
    mov [rsp + 32], r10         ; fifth parament
    call printf
    mov rax, 0                  ; return NULL
    jmp cleanup

cleanup:
    add rsp, 32 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    ret