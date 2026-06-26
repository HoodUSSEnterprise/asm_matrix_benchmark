; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-16 08:56:25
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:22:20
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\int\add_matrix_int.asm
; @Description: add matrix nasm code on windows
; -------------------------------------------------------------

global add_matrix_int
extern printf
extern malloc
extern free

section .rodata
    malloc_failed  db  "Memory allocation failed", 10, 0                            ; malloc failed msg
    invalid_param  db  "Invalid param!", 10, 0                                      ; invalid param msg
    dim_mismatch   db  "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0    ; dim mismatch msg

section .text

; MatrixInt *add_matrix_int(MatrixInt *m1, MatrixInt *m2);
; rcx = m1, rdx = m2

add_matrix_int:

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

    ; check dimension
    mov r8, [r14 + 8]                   ; m1->rows
    mov r9, [r14 + 16]                  ; m1->cols
    mov r10, [r15 + 8]                  ; m2->rows
    mov r11, [r15 + 16]                 ; m2->cols

    cmp r8, r10                         ; m1->rows == m2->rows
    jne dimension_mismatch
    cmp r9, r11                         ; m1->cols == m2->cols
    jne dimension_mismatch

    ; save the data len in rdi
    mov rdi, r8                         ; rdi = m1->rows
    imul rdi, r9                        ; rdi = m1->rows * m1->cols

    ; malloc res 24 bytes
    mov rcx, 24
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rcx, rdi
    shl rcx, 2                          ; rcx *= 4
    call malloc
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax                      ; res->data = new malloc data
    mov r9, [r14 + 8]                   ; r9 = m1->rows
    mov r10, [r14 + 16]                 ; r10 = m1->cols
    mov [rbx + 8], r9                   ; res->rows = m1->rows
    mov [rbx + 16], r10                 ; res->cols = m1->cols

    ; add m1 and m2
    xor rcx, rcx                        ; i = 0
    mov r13, [rbx]
    mov r9, [r14]                       ; r9 = m1->data
    mov r10, [r15]                      ; r10 = m2->data

on_loop:
    cmp rcx, rdi                        ; i < rdi
    jge end

    ; res->data[rcx] = m1->data[rcx] + m2->data[rcx]
    mov r8d, [r9 + rcx * 4]
    add r8d, [r10 + rcx * 4]

    mov [r13 + rcx * 4], r8d
    inc rcx                             ; i++
    jmp on_loop

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

end:

    mov rax, rbx

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
