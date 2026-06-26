; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-20 16:10:25
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:20:15
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\int\transpose_matrix_int.asm
; @Description: get transpose matrix nasm code on linux
; -------------------------------------------------------------

global transpose_matrix_int
extern malloc
extern free
extern printf

section .rodata
    malloc_failed  db  "Memory allocation failed", 10, 0    ; malloc failed msg
    invalid_param  db  "Invalid param!", 10, 0              ; invalid param msg

section .text

; MatrixInt *transpose_matrix_int(MatrixInt *m);
; rcx = m

transpose_matrix_int:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14, rdi                        ; r14 = m

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rdi]                      ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rdi

    ; load dims
    mov r8, [r14 + 8]                   ; rows
    mov r9, [r14 + 16]                  ; cols
    cmp r8, 0
    je null_ptr
    cmp r9, 0
    je null_ptr

    ; preserve total count in r12
    mov r12, r8
    imul r12, r9                        ; r12 = rows * cols

    ; malloc res struct
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct
    mov rbx, rax

    ; malloc res->data (count * 4)
    mov rdi, r12
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax                      ; res->data = new malloc data
    mov r9, [r14 + 8]                   ; r9 = m->rows
    mov r10, [r14 + 16]                 ; r10 = m->cols
    mov [rbx + 8], r10                  ; res->rows = m->cols
    mov [rbx + 16], r9                  ; res->cols = m->rows

    ; init loop
    xor rdi, rdi                        ; i = 0
    mov r11, [r14]                      ; r11 = m->data
    mov r13, [rbx]                      ; r13 = res->data

loop1:
    cmp rdi, r10                        ; i < res->rows (m->cols)
    jge end
    xor rsi, rsi

loop2:
    cmp rsi, r9                         ; j < res->cols (m->rows)
    jge inc_rdi

    ; index of m: j * m->cols + i
    mov r8, r10
    imul r8, rsi
    add r8, rdi
    mov ecx, [r11 + r8 * 4]

    ; index of res: i * res->cols + j
    mov r8, r9
    imul r8, rdi
    add r8, rsi
    mov [r13 + r8 * 4], ecx

    inc rsi
    jmp loop2

inc_rdi:
    inc rdi
    jmp loop1

malloc_fail_struct:
    lea rdi, [rel malloc_failed]
    xor eax, eax
    sub rsp, 8
    call printf wrt ..plt
    add rsp, 8
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rdi, [rel malloc_failed]
    xor eax, eax
    sub rsp, 8
    call printf wrt ..plt
    add rsp, 8
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]
    xor eax, eax
    sub rsp, 8
    call printf wrt ..plt
    add rsp, 8
    mov rax, 0
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
