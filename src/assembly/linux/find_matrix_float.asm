;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:38:22
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:43:25
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\find_matrix_float.asm
; @Description: find elem position in matrix float nasm code on linux
;-------------------------------------------------------------

global find_elem_float
extern puts
extern malloc

section .rodata
    invalid_param db "Invalid param!", 0
    malloc_failed db "Memory allocation failed", 0
    epsilon dd 1e-6
    abs_mask dd 0x7FFFFFFF

section .text

; bool find_elem_float(MatrixFloat *m, float elem, Point *pos);
; rdi = m, xmm0 = elem, rsi = pos (System V)
find_elem_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi
    movss xmm15, xmm0
    mov r13, rsi

    test r14, r14
    jz null_ptr

    mov r14, [rdi]
    test r14, r14
    jz null_ptr

    mov r14, rdi

    test r13, r13
    jz malloc_pos
    jmp init_loop

malloc_pos:
    mov rdi, 16
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail
    mov r13, rax

init_loop:
    xor rdi, rdi
    mov r8, [r14 + 8]
    mov r9, [r14 + 16]
    mov r11, [r14]
    movss xmm14, [rel epsilon]
    movd xmm13, [rel abs_mask]

loop1:
    cmp rdi, r8
    jge no_find
    xor rsi, rsi

    loop2:
        cmp rsi, r9
        jge inc_rdi

        mov r10, r9
        imul r10, rdi
        add r10, rsi

        movss xmm0, [r11 + r10 * 4]
        subss xmm0, xmm15
        andps xmm0, xmm13
        comiss xmm0, xmm14
        jb end
        inc rsi
        jmp loop2

inc_rdi:
    inc rdi
    jmp loop1

null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

no_find:
    mov rax, 0
    jmp cleanup

end:
    mov [r13], rdi
    mov [r13 + 8], rsi
    mov rax, 1
    jmp cleanup

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
