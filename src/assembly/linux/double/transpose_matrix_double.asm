; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:30:26
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:16:49
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\double\transpose_matrix_double.asm
; @Description: get transpose matrix double nasm code on linux
; -------------------------------------------------------------

global transpose_matrix_double
extern malloc
extern free
extern printf

section .rodata
    malloc_failed  db  "Memory allocation failed", 10, 0    ; malloc failed msg
    invalid_param  db  "Invalid param!", 10, 0              ; invalid param msg

section .text

; MatrixDouble *transpose_matrix_double(MatrixDouble *m);
; rdi = m (System V)

transpose_matrix_double:

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

    ; save the data len
    mov rdi, [r14 + 8]                  ; rdi = m->rows
    imul rdi, [r14 + 16]                ; rdi = m->rows * m->cols
    mov r12, rdi                        ; preserve count

    ; malloc res 24 bytes
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rdi, r12
    shl rdi, 3                          ; rdi *= 8
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax                      ; res->data = new malloc data
    mov r9, [r14 + 8]                   ; r9 = m->rows
    mov r10, [r14 + 16]                 ; r10 = m->cols
    mov [rbx + 8], r10                  ; res->rows = m->cols
    mov [rbx + 16], r9                  ; res->cols = m->rows

    ; init loop condition
    xor rdi, rdi                        ; i = 0
    mov r11, [r14]                      ; r11 = m->data
    mov r12, [rbx]                      ; r12 = res->data

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
        movsd xmm0, [r11 + r8 * 8]

        ; calc index of res
        mov r8, r9                      ; r8 = res->cols
        imul r8, rdi                    ; r8 *= i
        add r8, rsi                     ; r8 += j

        ; res->data[i * res->cols + j] = xmm0
        movsd [r12 + r8 * 8], xmm0
        inc rsi                         ; j++
        jmp loop2

inc_rdi:
    inc rdi                             ; i++
    jmp loop1

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
