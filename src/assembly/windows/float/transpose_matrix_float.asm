; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 18:52:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:22:17
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\float\transpose_matrix_float.asm
; @Description: get transpose matrix float nasm code on windows
; -------------------------------------------------------------

global transpose_matrix_float
extern malloc
extern free
extern printf

section .rodata
    malloc_failed  db  "Memory allocation failed", 10, 0    ; malloc failed msg
    invalid_param  db  "Invalid param!", 10, 0              ; invalid param msg

section .text

; MatrixFloat *transpose_matrix_float(MatrixFloat *m);
; rcx = m

transpose_matrix_float:

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

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rcx]                      ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    ; save the data len in rdi
    mov rdi, [r14 + 8]                  ; rdi = m1->rows
    imul rdi, [r14 + 16]                ; rdi = m1->rows * m1->cols

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

    mov [rbx], rax                      ; res->data = new malloc data
    mov r9, [r14 + 8]                   ; r9 = m->rows
    mov r10, [r14 + 16]                 ; r10 = m->cols
    mov [rbx + 8], r10                  ; res->rows = m->cols
    mov [rbx + 16], r9                  ; res->cols = m->rows

    ; init loop conditino
    xor rdi, rdi                        ; i = 0
    mov r11, [r14]                      ; r11 = m->data
    mov r12, [rbx]                      ; r13 = res->data

loop1:
    cmp rdi, r10                        ; i < res->rows
    jge end
    xor rsi, rsi

    loop2:
        cmp rsi, r9                     ; j < res->cols
        jge inc_rdi

        ; calc index of m
        mov r8, r10                     ; r8 = m->cols
        imul r8, rsi                    ; r8 *= j
        add r8, rdi                     ; r8 += i

        ; xmm0 = m->data[j * m->cols + i]
        movss xmm0, [r11 + r8 * 4]

        ; calc index of res
        mov r8, r9                      ; r8 = res->cols
        imul r8, rdi                    ; r8 *= i
        add r8, rsi                     ; r8 += j

        ; m->data[i * res->cols + j] = xmm0
        movss [r12 + r8 * 4], xmm0
        inc rsi                         ; j++
        jmp loop2

inc_rdi:
    inc rdi                             ; i++
    jmp loop1

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

end:
    mov rax, rbx

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
