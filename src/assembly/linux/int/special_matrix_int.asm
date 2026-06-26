global identity_matrix_int, diag_matrix_int, eye_matrix_int, zero_matrix_int
extern malloc
extern free
extern puts
extern memset

section .rodata
    malloc_failed  db  "Memory allocation failed", 0    ; malloc failed msg
    invalid_param  db  "Invalid param!", 0              ; invalid param msg

section .text

; ---------------------------------------------------------------------------------------------
; MatrixInt *identity_matrix_int(int order);
; edi = order
; ---------------------------------------------------------------------------------------------

identity_matrix_int:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40                         ; allocate shadow space for printf

    mov r14d, edi                       ; r14 = order

    ; check param order
    cmp r14d, 0
    jle null_ptr

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; save the data len in r13
    mov r13, r14                        ; r13 = order
    imul r13, r14                       ; r13 = order * order

    ; malloc res->data
    mov rdi, r13
    shl rdi, 2                          ; rdi *= 4
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    ; init res->data with 0, use memset function
    mov r12, rax                        ; r12 = malloc res data
    mov rdi, r12                        ; rdi = malloc res data
    mov esi, 0                          ; memset value = 0
    mov rdx, r13                        ; number sizeof int
    shl rdx, 2                          ; sizeof res data
    call memset wrt ..plt

    ; init res param
    mov [rbx], rax                      ; res->data = new malloc data
    mov [rbx + 8], r14                  ; res->rows = order
    mov [rbx + 16], r14                 ; res->cols = order

    ; set data 
    xor rdi, rdi                        ; i = 0
    mov rsi, [rbx]                      ; rsi = res->data

loopidentity:
    cmp rdi, r14                        ; i < order
    jge end

    mov r8, r14                         ; r8 = order
    imul r8, rdi                        ; r8 *= i
    add r8, rdi                         ; r8 += i

    ; means res->data[i][i]
    mov dword[rsi + r8 * 4], 1          ; res->data[i * order + i]
    inc rdi
    jmp loopidentity

; ---------------------------------------------------------------------------------------------
; MatrixInt *diag_matrix_int(int *data, size_t len);
; rdi = data, rsi = len
; ---------------------------------------------------------------------------------------------

diag_matrix_int:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14, rdi                        ; r14 = data
    mov r15, rsi                        ; r15 = len

    ; check param data
    test r14, r14
    jz null_ptr
    ; check param len
    cmp r15, 0
    jle null_ptr

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; save the data len in r13
    mov r13, r15                        ; r13 = order
    imul r13, r15                       ; r13 = order * order

    ; malloc res->data
    mov rdi, r13
    shl rdi, 2                          ; rdi *= 4
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    ; init res->data with 0, use memset function
    mov r12, rax                        ; r12 = malloc res data
    mov rdi, r12                        ; rdi = malloc res data
    mov esi, 0                          ; memset value = 0
    mov rdx, r13                        ; number sizeof int
    shl rdx, 2                          ; sizeof res data
    call memset wrt ..plt

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
    mov r11d, [r14 + rdi * 4]           ; r11d = data[i]
    mov [rsi + r8 * 4], r11d            ; res->data[i * len + i] = data[i]
    inc rdi
    jmp loopdiag

; ---------------------------------------------------------------------------------------------
; MatrixInt *eye_matrix_int(int rows, int cols);
; edi = rows, esi = cols
; ---------------------------------------------------------------------------------------------

eye_matrix_int:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14d, edi                       ; r14d = rows
    mov r15d, esi                       ; r15d = cols

    ; check param rows
    cmp r14d, 0
    jle null_ptr
    ; check param cols
    cmp r15d, 0
    jle null_ptr

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; save the data len in r13d
    mov r13d, r14d                      ; r13d = rows
    imul r13d, r15d                     ; r13d = rows * cols

    ; malloc res->data
    mov edi, r13d
    shl edi, 2                          ; edi *= 4
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    ; init res->data with 0, use memset function
    mov r12, rax                        ; r12 = malloc res data
    mov rdi, r12                        ; rdi = malloc res data
    mov esi, 0                          ; memset value = 0
    mov rdx, r13                        ; number sizeof int
    shl rdx, 2                          ; sizeof res data
    call memset wrt ..plt

    ; init res param
    mov [rbx], rax                      ; res->data = new malloc data
    mov [rbx + 8], r14                  ; res->rows = rows
    mov [rbx + 16], r15                 ; res->cols = cols

    ; set data 
    xor rdi, rdi                        ; i = 0
    mov rsi, [rbx]                      ; rsi = res->data

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

    mov dword[rsi + r8 * 4], 1          ; res->data[i * cols + i] = 1
    inc rdi
    jmp loopeye

; ---------------------------------------------------------------------------------------------
; MatrixInt *zero_matrix_int(int rows, int cols);
; edi = rows, esi = cols
; ---------------------------------------------------------------------------------------------

zero_matrix_int:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r14d, edi                       ; r14d = rows
    mov r15d, esi                       ; r15d = cols

    ; check param rows
    cmp r14, 0
    jle null_ptr
    ; check param cols
    cmp r15, 0
    jle null_ptr

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; save the data len in r13d
    mov r13d, r14d                      ; r13d = rows
    imul r13d, r15d                     ; r13d = rows * cols

    ; malloc res->data
    mov edi, r13d
    shl edi, 2                          ; edi *= 4
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    ; init res->data with 0, use memset function
    mov r12, rax                        ; r12 = malloc res data
    mov rdi, r12                        ; rdi = malloc res data
    mov esi, 0                          ; memset value = 0
    mov rdx, r13                        ; number sizeof int
    shl rdx, 2                          ; sizeof res data
    call memset wrt ..plt

    ; init res param
    mov [rbx], rax                      ; res->data = new malloc data
    mov [rbx + 8], r14                  ; res->rows = rows
    mov [rbx + 16], r15                 ; res->cols = cols
    jmp end

malloc_fail_struct:
    lea rdi, [rel malloc_failed]        ; rdi = malloc_failed
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rdi, [rel malloc_failed]        ; rdi = malloc_failed
    call puts wrt ..plt
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]        ; rdi = invalid_param
    call puts wrt ..plt
    mov rax, 0                          ; return NULL
    jmp cleanup

end:
    mov rax, rbx

cleanup:
    add rsp, 40                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
