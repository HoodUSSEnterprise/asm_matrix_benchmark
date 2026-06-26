; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:38:22
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:18:05
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\float\trace_matrix_float.asm
; @Description: the trace of matrix float nasm code on linux
; -------------------------------------------------------------

global trace_matrix_float
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 10, 0
    no_square      db  "It is not a square!", 0

section .text

; bool trace_matrix_float(MatrixFloat *m, float *trace)
; rdi = m, rsi = trace (System V)

trace_matrix_float:
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi
    mov r15, rsi

    test r14, r14
    jz null_ptr

    mov r14, [rdi]
    test r14, r14
    jz null_ptr

    mov r14, rdi

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    cmp r9, 0
    je null_ptr
    cmp r9, 0
    je null_ptr
    cmp r8, r9
    jne not_a_square

    xor rdi, rdi
    xorps xmm0, xmm0
    mov r9, [r14]

loop1:
    cmp rdi, r8
    jge end

    mov r11, r8
    imul r11, rdi
    add r11, rdi

    addss xmm0, [r9 + r11 * 4]
    inc rdi
    jmp loop1

null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

not_a_square:
    lea rdi, [rel no_square]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

end:
    movss [r15], xmm0
    mov rax, 1

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
