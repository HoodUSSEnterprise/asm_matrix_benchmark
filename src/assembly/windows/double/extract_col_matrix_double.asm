; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:20:39
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\double\extract_col_matrix_double.asm
; @Description: extract col matrix double nasm code on windows
; -------------------------------------------------------------

global extract_col_double

extern malloc
extern free
extern printf
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 10, 0              ; invalid param msg
    malloc_failed  db  "Memory allocation failed", 10, 0    ; malloc failed msg

section .text

; MatrixDouble *extract_col_double(MatrixDouble *m, size_t index);
; rcx = m, rdx = index

extract_col_double:

    ; save callee_register
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14, rcx                        ; r14 = m
    mov r15, rdx                        ; r15 = index

    ; check m
    test r14, r14
    jz null_ptr

    ; check m->data
    mov r14, [rcx]
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    ; check dimension and index
    mov r8, [r14 + 8]                   ; m->rows

    cmp r15, r8
    jge null_ptr

    ; malloc res 24 bytes
    mov rcx, 24
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rcx, [r14 + 8]
    shl rcx, 3                          ; rcx *= 8
    call malloc
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax                      ; res->data = new malloc data
    mov r10, [r14 + 8]                  ; r10 = m->rows
    mov [rbx + 8], r10                  ; res->rows = m->rows
    mov qword[rbx + 16], 1              ; res->cols = 1

    ; init loop
    xor rsi, rsi                        ; i = 0
    mov rdi, [r14 + 8]                  ; m->rows
    mov r12, [rbx]                      ; r12 = res->data
    mov r10, [r14 + 16]                 ; m->cols
    mov r13, [r14]                      ; r13 = m->data

loop1:
    cmp rsi, rdi                        ; i < m->rows
    jge end

    mov r8, rsi                         ; r8 = i
    imul r8, r10                        ; r8 *= m->cols
    add r8, r15                         ; r8 += index

    movsd xmm0, [r13 + r8 * 8]          ; xmm0 = m->data[i * m->cols + index]
    movsd [r12 + rsi * 8], xmm0         ; res->data[i] = m->data[i * m->cols + index]

    inc rsi                             ; i++
    jmp loop1

end:
    mov rax, rbx
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

cleanup:
    add rsp, 32                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret
