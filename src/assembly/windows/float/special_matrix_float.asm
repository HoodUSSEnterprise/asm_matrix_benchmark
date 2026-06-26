; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 18:52:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:22:11
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\float\special_matrix_float.asm
; @Description: some special matrix like identity matrix, diag matrix,
; eye_matrix and zero matrix float nasm code on windows
; -------------------------------------------------------------

global identity_matrix_float, diag_matrix_float, eye_matrix_float, zero_matrix_float
extern malloc
extern free
extern puts
extern memset

section .rodata
    malloc_failed  db  "Memory allocation failed", 0    ; malloc failed msg
    invalid_param  db  "Invalid param!", 0              ; invalid param msg
    one_float      dd  1.0

section .text

; ---------------------------------------------------------------------------------------------
; MatrixFloat *identity_matrix_float(int order);
; ecx = order
; ---------------------------------------------------------------------------------------------

identity_matrix_float:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14d, ecx                       ; r14 = order

    ; check param order
    cmp r14d, 0
    jle null_ptr

    ; save the data len in rdi
    mov rdi, r14                        ; rdi = order
    imul rdi, r14                       ; rdi = order * order

    ; malloc res 24 bytes
    mov rcx, 24
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rcx, rdi
    shl rcx, 2                          ; rcx *= 4 (sizeof float)
    call malloc
    test rax, rax
    jz malloc_fail_data

    ; init res->data with 0, use memset function
    mov r12, rax                        ; r12 = malloc res data
    mov rcx, r12                        ; rcx = malloc res data
    mov edx, 0                          ; memset value = 0
    mov r8, rdi                         ; number sizeof float
    shl r8, 2                           ; sizeof res data
    call memset

    ; init res param
    mov [rbx], rax                      ; res->data = new malloc data
    mov [rbx + 8], r14                  ; res->rows = order
    mov [rbx + 16], r14                 ; res->cols = order

    ; set data
    xor rdi, rdi                        ; i = 0
    mov rsi, [rbx]                      ; rsi = res->data
    movss xmm0, [rel one_float]

loopidentity:
    cmp rdi, r14                        ; i < order
    jge end

    mov r8, r14                         ; r8 = order
    imul r8, rdi                        ; r8 *= i
    add r8, rdi                         ; r8 += i

    ; means res->data[i][i]
    movss [rsi + r8 * 4], xmm0          ; res->data[i * order + i] = 1.0
    inc rdi
    jmp loopidentity

; ---------------------------------------------------------------------------------------------
; MatrixFloat *diag_matrix_float(float *data, size_t len);
; rcx = data, rdx = len
; ---------------------------------------------------------------------------------------------

diag_matrix_float:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14, rcx                        ; r14 = data
    mov r15, rdx                        ; r15 = len

    ; check param data
    test r14, r14
    jz null_ptr
    ; check param len
    cmp r15, 0
    jle null_ptr

    ; save the data len in rdi
    mov rdi, r15                        ; rdi = order
    imul rdi, r15                       ; rdi = order * order

    ; malloc res 24 bytes
    mov rcx, 24
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rcx, rdi
    shl rcx, 2                          ; rcx *= 4 (sizeof float)
    call malloc
    test rax, rax
    jz malloc_fail_data

    ; init res->data with 0, use memset function
    mov r12, rax                        ; r12 = malloc res data
    mov rcx, r12                        ; rcx = malloc res data
    mov edx, 0                          ; memset value = 0
    mov r8, rdi                         ; number sizeof float
    shl r8, 2                           ; sizeof res data
    call memset

    ; init res param
    mov [rbx], rax                      ; res->data = new malloc data
    mov [rbx + 8], r15                  ; res->rows = len
    mov [rbx + 16], r15                 ; res->cols = len

    ; set data
    xor rdi, rdi                        ; i = 0
    mov rsi, [rbx]                      ; rsi = res->data

loopdiag:
    cmp rdi, r15                        ; i < len
    jge end

    mov r8, r15                         ; r8 = len
    imul r8, rdi                        ; r8 *= i
    add r8, rdi                         ; r8 += i

    ; means res->data[i][i]
    movss xmm0, [r14 + rdi * 4]         ; xmm0 = data[i]
    movss [rsi + r8 * 4], xmm0          ; res->data[i * len + i] = data[i]
    inc rdi
    jmp loopdiag

; ---------------------------------------------------------------------------------------------
; MatrixFloat *eye_matrix_float(int rows, int cols);
; ecx = rows, edx = cols
; ---------------------------------------------------------------------------------------------

eye_matrix_float:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14d, ecx                       ; r14d = rows
    mov r15d, edx                       ; r15d = cols

    ; check param rows
    cmp r14d, 0
    jle null_ptr
    ; check param cols
    cmp r15d, 0
    jle null_ptr

    ; save the data len in edi
    mov edi, r14d                       ; edi = rows
    imul edi, r15d                      ; edi = rows * cols

    ; malloc res 24 bytes
    mov rcx, 24
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov ecx, edi
    shl ecx, 2                          ; ecx *= 4 (sizeof float)
    call malloc
    test rax, rax
    jz malloc_fail_data

    ; init res->data with 0, use memset function
    mov r12, rax                        ; r12 = malloc res data
    mov rcx, r12                        ; rcx = malloc res data
    mov edx, 0                          ; memset value = 0
    mov r8, rdi                         ; number sizeof float
    shl r8, 2                           ; sizeof res data
    call memset

    ; init res param
    mov [rbx], rax                      ; res->data = new malloc data
    mov [rbx + 8], r14                  ; res->rows = rows
    mov [rbx + 16], r15                 ; res->cols = cols

    ; set data
    xor rdi, rdi                        ; i = 0
    mov rsi, [rbx]                      ; rsi = res->data
    movss xmm0, [rel one_float]

    cmp r14d, r15d                      ; compare rows and cols
    jge select_r15d
    mov r9, r14
    jmp loopeye

select_r15d:
    mov r9, r15

loopeye:
    cmp rdi, r9                         ; i < min(rows, cols)
    jge end

    mov r8, r15                         ; r8 = cols
    imul r8, rdi                        ; r8 *= i
    add r8, rdi                         ; r8 += i

    movss [rsi + r8 * 4], xmm0          ; res->data[i * cols + i] = 1.0
    inc rdi
    jmp loopeye

; ---------------------------------------------------------------------------------------------
; MatrixFloat *zero_matrix_float(int rows, int cols);
; ecx = rows, edx = cols
; ---------------------------------------------------------------------------------------------

zero_matrix_float:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14d, ecx                       ; r14d = rows
    mov r15d, edx                       ; r15d = cols

    ; check param rows
    cmp r14, 0
    jle null_ptr
    ; check param cols
    cmp r15, 0
    jle null_ptr

    ; save the data len in edi
    mov edi, r14d                       ; edi = rows
    imul edi, r15d                      ; edi = rows * cols

    ; malloc res 24 bytes
    mov rcx, 24
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov ecx, edi
    shl ecx, 2                          ; ecx *= 4 (sizeof float)
    call malloc
    test rax, rax
    jz malloc_fail_data

    ; init res->data with 0, use memset function
    mov r12, rax                        ; r12 = malloc res data
    mov rcx, r12                        ; rcx = malloc res data
    mov edx, 0                          ; memset value = 0
    mov r8, rdi                         ; number sizeof float
    shl r8, 2                           ; sizeof res data
    call memset

    ; init res param
    mov [rbx], rax                      ; res->data = new malloc data
    mov [rbx + 8], r14                  ; res->rows = rows
    mov [rbx + 16], r15                 ; res->cols = cols
    jmp end

malloc_fail_struct:
    lea rcx, [rel malloc_failed]        ; rcx = malloc_failed
    call puts
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rcx, [rel malloc_failed]        ; rcx = malloc_failed
    call puts
    mov rcx, rbx
    call free
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rcx, [rel invalid_param]        ; rcx = invalid_param
    call puts
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
