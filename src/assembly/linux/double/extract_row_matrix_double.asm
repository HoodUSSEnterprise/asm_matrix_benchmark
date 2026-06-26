; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:31:52
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 12:18:18
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\double\extract_row_matrix_double.asm
; @Description: extract row matrix double nasm code on linux
; -------------------------------------------------------------

global extract_row_double

extern malloc
extern free
extern printf
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 10, 0 ; invalid param msg              ; invalid param msg
    malloc_failed  db  "Memory allocation failed", 10, 0 ; malloc failed msg    ; malloc failed msg

section .text

; MatrixDouble *extract_row_double(MatrixDouble *m, size_t index);
; rdi = m, rsi = index (System V)

extract_row_double:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14, rdi                        ; r14 = m
    mov r15, rsi                        ; r15 = index

    ; check m
    test r14, r14
    jz null_ptr

    ; check m->data
    mov r14, [rdi]
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rdi

    ; check dimension and index
    mov r8, [r14 + 8]                   ; m->rows

    cmp r15, r8
    jge null_ptr

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rdi, [r14 + 16]
    shl rdi, 3                          ; rdi *= 8
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax                      ; res->data = new malloc data
    mov r10, [r14 + 16]                 ; r10 = m->cols
    mov qword[rbx + 8], 1               ; res->rows = 1
    mov [rbx + 16], r10                 ; res->cols = m->cols

    ; init loop
    xor rsi, rsi                        ; i = 0
    mov rdi, [r14 + 16]                 ; m->cols
    mov r12, [rbx]                      ; r12 = res->data
    mov r13, [r14]                      ; r13 = m->data

loop1:
    cmp rsi, rdi                        ; i < m->cols
    jge end

    mov r8, r15                         ; r8 = index
    imul r8, rdi                        ; r8 *= m->cols
    add r8, rsi                         ; r8 += i

    movsd xmm0, [r13 + r8 * 8]          ; xmm0 = m->data[index * m->cols + i]
    movsd [r12 + rsi * 8], xmm0         ; res->data[i] = m->data[index * m->cols + i]

    inc rsi                             ; i++
    jmp loop1

end:
    mov rax, rbx
    jmp cleanup

malloc_fail_struct:
    lea rdi, [rel malloc_failed]        ; rdi = malloc_failed
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rdi, [rel malloc_failed]        ; rdi = malloc_failed
    xor eax, eax
    call printf wrt ..plt
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]        ; rdi = invalid_param
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0                          ; return NULL
    jmp cleanup

cleanup:
    add rsp, 32                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
