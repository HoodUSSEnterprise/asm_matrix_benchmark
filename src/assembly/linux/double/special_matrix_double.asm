; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:16:30
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\double\special_matrix_double.asm
; @Description: some special matrix like identity matrix, diag matrix,
; eye_matrix and zero matrix double nasm code on linux
; -------------------------------------------------------------

global identity_matrix_double, diag_matrix_double, eye_matrix_double, zero_matrix_double
extern malloc
extern free
extern puts
extern memset

section .rodata
    malloc_failed  db  "Memory allocation failed", 0    ; malloc failed msg
    invalid_param  db  "Invalid param!", 0              ; invalid param msg
    one            dq  1.0
    zero           dq  0.0

section .text

; ---------------------------------------------------------------------------------------------
; MatrixDouble *identity_matrix_double(int order);
; edi = order (System V)
; ---------------------------------------------------------------------------------------------

identity_matrix_double:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14d, edi                       ; r14 = order

    cmp r14d, 0
    jle null_ptr

    ; count = order * order
    mov r13, r14
    imul r13, r14                       ; r13 = count

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data (count * 8 bytes)
    mov rdi, r13
    shl rdi, 3
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov r12, rax                        ; r12 = res->data

    ; memset(res->data, 0, count * 8)
    mov rdi, r12
    xor esi, esi
    mov rdx, r13
    shl rdx, 3
    call memset wrt ..plt

    ; init res fields
    mov [rbx], r12                      ; res->data
    mov [rbx + 8], r14                  ; res->rows = order
    mov [rbx + 16], r14                 ; res->cols = order

    ; set diagonal to 1.0
    xor rdi, rdi                        ; i = 0
    movsd xmm0, [rel one]

loopidentity:
    cmp rdi, r14                        ; i < order
    jge end

    mov r8, r14                         ; r8 = order
    imul r8, rdi                        ; r8 *= i
    add r8, rdi                         ; r8 += i

    movsd [r12 + r8 * 8], xmm0          ; res->data[i * order + i] = 1.0
    inc rdi
    jmp loopidentity

; ---------------------------------------------------------------------------------------------
; MatrixDouble *diag_matrix_double(double *data, size_t len);
; rdi = data, rsi = len (System V)
; ---------------------------------------------------------------------------------------------

diag_matrix_double:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi                        ; r14 = data
    mov r15, rsi                        ; r15 = len

    test r14, r14
    jz null_ptr
    cmp r15, 0
    jle null_ptr

    ; count = len * len
    mov r13, r15
    imul r13, r15                       ; r13 = count

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rdi, r13
    shl rdi, 3
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov r12, rax                        ; r12 = res->data

    ; memset(res->data, 0, count * 8)
    mov rdi, r12
    xor esi, esi
    mov rdx, r13
    shl rdx, 3
    call memset wrt ..plt

    ; init res fields
    mov [rbx], r12                      ; res->data
    mov [rbx + 8], r15                  ; res->rows = len
    mov [rbx + 16], r15                 ; res->cols = len

    ; set diagonal values
    xor rdi, rdi                        ; i = 0

loopdiag:
    cmp rdi, r15                        ; i < len
    jge end

    mov r8, r15                         ; r8 = len
    imul r8, rdi                        ; r8 *= i
    add r8, rdi                         ; r8 += i

    movsd xmm0, [r14 + rdi * 8]         ; xmm0 = data[i]
    movsd [r12 + r8 * 8], xmm0          ; res->data[i * len + i] = data[i]
    inc rdi
    jmp loopdiag

; ---------------------------------------------------------------------------------------------
; MatrixDouble *eye_matrix_double(int rows, int cols);
; edi = rows, esi = cols (System V)
; ---------------------------------------------------------------------------------------------

eye_matrix_double:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14d, edi                       ; r14d = rows
    mov r15d, esi                       ; r15d = cols

    cmp r14d, 0
    jle null_ptr
    cmp r15d, 0
    jle null_ptr

    ; count = rows * cols
    mov r13d, r14d
    imul r13d, r15d                     ; r13d = count
    movsxd r13, r13d

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rdi, r13
    shl rdi, 3
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov r12, rax                        ; r12 = res->data

    ; memset(res->data, 0, count * 8)
    mov rdi, r12
    xor esi, esi
    mov rdx, r13
    shl rdx, 3
    call memset wrt ..plt

    ; init res fields
    mov [rbx], r12                      ; res->data
    mov [rbx + 8], r14                  ; res->rows = rows
    mov [rbx + 16], r15                 ; res->cols = cols

    ; set eye values
    xor rdi, rdi                        ; i = 0
    movsd xmm0, [rel one]

    cmp r14d, r15d
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

    movsd [r12 + r8 * 8], xmm0          ; res->data[i * cols + i] = 1.0
    inc rdi
    jmp loopeye

; ---------------------------------------------------------------------------------------------
; MatrixDouble *zero_matrix_double(int rows, int cols);
; edi = rows, esi = cols (System V)
; ---------------------------------------------------------------------------------------------

zero_matrix_double:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14d, edi                       ; r14d = rows
    mov r15d, esi                       ; r15d = cols

    cmp r14d, 0
    jle null_ptr
    cmp r15d, 0
    jle null_ptr

    ; count = rows * cols
    mov r13d, r14d
    imul r13d, r15d
    movsxd r13, r13d

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rdi, r13
    shl rdi, 3
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov r12, rax                        ; r12 = res->data

    ; memset(res->data, 0, count * 8)
    mov rdi, r12
    xor esi, esi
    mov rdx, r13
    shl rdx, 3
    call memset wrt ..plt

    ; init res fields
    mov [rbx], r12                      ; res->data
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
    add rsp, 32                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
