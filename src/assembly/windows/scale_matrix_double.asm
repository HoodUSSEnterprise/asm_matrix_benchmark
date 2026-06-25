;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-23 20:56:08
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-25 15:31:59
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\scale_matrix_double.asm
; @Description: scale matrix double nasm code on windows
;-------------------------------------------------------------
global scale_matrix_double
extern printf
extern malloc
extern free

section .rodata
    malloc_failed db "Memory allocation failed", 10, 0                         ; malloc failed msg
    invalid_param db "Invalid param!", 10, 0                                   ; invalid param msg

section .text

; MatrixDouble *scale_matrix_double(MatrixDouble *m, double scale);
; rcx = m, xmm1 = scale

scale_matrix_double:
    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40 ; allocate shadow space for printf

    movsd [rsp + 32], xmm15

    mov r14, rcx ; r14 = m
    movsd xmm15, xmm1 ; xmm15 = scale

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rcx] ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    ; get dimension
    mov r8, [r14 + 8]   ; m->rows
    mov r9, [r14 + 16]  ; m->cols

    ; save the data len in rdi
    mov rdi, r8     ; rdi = m1->rows
    imul rdi, r9    ; rdi = m1->rows * m1->cols

    ; malloc res 24 bytes
    mov rcx, 24 
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rcx, rdi
    shl rcx, 3 ; rcx *= 8
    call malloc
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax      ; res->data = new malloc data
    mov r9, [r14 + 8]   ; r9 = m1->rows
    mov r10, [r14 + 16] ; r10 = m2->cols
    mov [rbx + 8], r9   ; res->rows = m1->rows
    mov [rbx + 16], r10 ; res->cols = m1->cols

    ; scale m
    xor rcx, rcx ; i = 0
    mov r13, [rbx]
    mov r9, [r14] ; r9 = m->data

on_loop:
    cmp rcx, rdi ; i < rdi
    jge end

    ; res->data[rcx] = m->data[rcx] * scale
    movsd xmm0, [r9 + rcx * 8]
    mulsd xmm0, xmm15

    movsd [r13 + rcx * 8], xmm0
    inc rcx ; i++
    jmp on_loop


malloc_fail_struct:
    lea rcx, [rel malloc_failed] ; rcx = malloc_failed
    call printf
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rcx, [rel malloc_failed] ; rcx = malloc_failed
    call printf
    mov rcx, rbx
    call free
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rcx, [rel invalid_param] ; rcx = invalid_param
    call printf
    mov rax, 0 ; return NULL
    jmp cleanup

end:

    mov rax, rbx

cleanup:

    movsd xmm15, [rsp + 32]
    add rsp, 40 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    ret