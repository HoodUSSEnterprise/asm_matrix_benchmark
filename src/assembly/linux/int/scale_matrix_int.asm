; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-16 18:45:24
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:20:05
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\int\scale_matrix_int.asm
; @Description: scale matrix nasm code on linux
; -------------------------------------------------------------

global scale_matrix_int
extern printf
extern malloc
extern free

section .rodata
    malloc_failed  db  "Memory allocation failed", 10, 0    ; malloc failed msg
    invalid_param  db  "Invalid param!", 10, 0              ; invalid param msg

section .text

; MatrixInt *scale_matrix_int(MatrixInt *m, int scale);
; rdi = m, rsi = scale (System V)

scale_matrix_int:
    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14, rdi                        ; r14 = m
    mov r15d, esi                       ; r15d = scale

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rdi]                      ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rdi

    ; get dimension
    mov r8, [r14 + 8]                   ; m->rows
    mov r9, [r14 + 16]                  ; m->cols

    ; save the data len in r13
    mov r13, r8                         ; rdi = m1->rows
    imul r13, r9                        ; rdi = m1->rows * m1->cols

    ; malloc res 24 bytes 
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rdi, r13
    shl rdi, 2                          ; rdi *= 4
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax                      ; res->data = new malloc data
    mov r9, [r14 + 8]                   ; r9 = m1->rows
    mov r10, [r14 + 16]                 ; r10 = m1->cols
    mov [rbx + 8], r9                   ; res->rows = m1->rows
    mov [rbx + 16], r10                 ; res->cols = m1->cols

    ; scale m
    xor rcx, rcx                        ; i = 0
    mov r12, [rbx]
    mov r9, [r14]                       ; r9 = m->data

on_loop:
    cmp rcx, r13                        ; i < r13
    jge end

    ; res->data[rcx] = m->data[rcx] * scale
    mov r8d, [r9 + rcx * 4]
    imul r8d, r15d

    mov [r12 + rcx * 4], r8d
    inc rcx                             ; i++
    jmp on_loop

malloc_fail_struct:
    lea rdi, [rel malloc_failed]        ; rdi = malloc_failed
    xor eax, eax
    sub rsp, 8
    call printf wrt ..plt
    add rsp, 8
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rdi, [rel malloc_failed]        ; rdi = malloc_failed
    xor eax, eax
    sub rsp, 8
    call printf wrt ..plt
    add rsp, 8
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]        ; rdi = invalid_param
    xor eax, eax
    sub rsp, 8
    call printf wrt ..plt
    add rsp, 8
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
    pop rbx
    ret
