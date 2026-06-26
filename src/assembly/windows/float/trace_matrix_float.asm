; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 18:52:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:22:15
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\float\trace_matrix_float.asm
; @Description: the trace of matrix float nasm code on windows
; -------------------------------------------------------------

global trace_matrix_float
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 10, 0     ; invalid param msg
    no_square      db  "It is not a square!", 0

section .text

; bool trace_matrix_float(MatrixFloat *m, float *trace)
; rcx = m, rdx = trace

trace_matrix_float:
    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for puts

    mov r14, rcx                        ; r14 = m
    mov r15, rdx                        ; r15 = trace

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rcx]                      ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    ; check is or not a square
    mov r8, [r14 + 8]                   ; m->rows
    mov r9, [r14 + 16]                  ; m->cols

    cmp r9, 0                           ; m->rows == 0
    je null_ptr
    cmp r9, 0                           ; m->cols == 0
    je null_ptr
    cmp r8, r9                          ; m->rows == m->cols
    jne not_a_square

    ; init loop condition
    xor rdi, rdi                        ; i = 0
    xorps xmm1, xmm1                    ; sum = 0.0
    mov r9, [r14]                       ; r9 = m->data

loop1:
    cmp rdi, r8                         ; i < m->rows
    jge end

    mov r11, r8                         ; r11 = m->cols
    imul r11, rdi                       ; r11 *= i
    add r11, rdi                        ; r11 += i

    addss xmm1, [r9 + r11 * 4]          ; sum += m->data[i * m->cols + i]
    inc rdi                             ; i++
    jmp loop1

null_ptr:
    lea rcx, [rel invalid_param]        ; rcx = invalid_param
    call puts
    mov rax, 0                          ; return false
    jmp cleanup

not_a_square:
    lea rcx, [rel no_square]
    call puts
    mov rax, 0                          ; return false
    jmp cleanup

end:
    movss [r15], xmm1                   ; (*trace) = sum
    mov rax, 1

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
