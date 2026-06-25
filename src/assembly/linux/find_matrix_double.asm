;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:30:26
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-25 15:15:39
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\find_matrix_double.asm
; @Description:  find elem position in matrix double nasm code on linux
;-------------------------------------------------------------

global find_elem_double
extern puts
extern malloc

section .rodata
    invalid_param db "Invalid param!", 0                                   ; invalid param msg
    malloc_failed db "Memory allocation failed", 0                         ; malloc failed msg
    epsilon dq 1e-6

section .text

; bool find_elem_double(MatrixDouble *m, double elem, Point *pos);
; rdi = m, xmm0 = elem, rsi = pos (System V)
find_elem_double:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 56 ; allocate shadow space for puts

    movsd [rsp + 32], xmm13
    movsd [rsp + 40], xmm14
    movsd [rsp + 48], xmm15
    mov r14, rdi    ; r14 = m
    movsd xmm15, xmm0 ; xmm15 = elem
    mov r13, rsi     ; r13 = pos

    ; check m
    test r14, r14
    jz null_ptr

    mov r14, [rdi] ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rdi

    ; check pos, if pos is null, malloc for pos
    test r13, r13
    jz malloc_pos
    jmp init_loop

malloc_pos:
    ; typedef struct Point
    ; {
    ;     size_t x;
    ;     size_t y;
    ; } Point;
    ; sizeof(Point) = 16
    mov rdi, 16
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail
    mov r13, rax

init_loop:
    ; init loop condition
    xor rdi, rdi ; i = 0
    mov r8, [r14 + 8] ; m->rows
    mov r9, [r14 + 16] ; m->cols
    mov r11, [r14]
    movsd xmm14, [rel epsilon] ; xmm14 = 1e-6
    mov r15, 0x7FFFFFFFFFFFFFFF ; for fabs
    movq xmm13, r15
loop1:
    cmp rdi, r8 ; i < m->rows
    jge no_find
    xor rsi, rsi

    loop2:
        cmp rsi, r9 ; j < m->cols
        jge inc_rdi

        mov r10, r9 ; r10 = m->cols
        imul r10, rdi ; r10 *= i
        add r10, rsi ; r10 += j

        ; compare m->data[i * m->cols + j] with elem using epsilon
        movsd xmm0, [r11 + r10 * 8] ; xmm0 = m->data[i * m->cols + j]
        subsd xmm0, xmm15 ; xmm0 = value - elem
        ; fabs: clear sign bit
        andps xmm0, xmm13 ; xmm0 = fabs(value - elem)
        comisd xmm0, xmm14 ; compare with epsilon
        jb end ; if fabs < epsilon, found
        inc rsi ; j++
        jmp loop2

inc_rdi:
    inc rdi; i++
    jmp loop1

null_ptr:
    lea rdi, [rel invalid_param] ; rdi = invalid_param
    call puts wrt ..plt
    mov rax, 0 ; return false
    jmp cleanup

malloc_fail:
    lea rdi, [rel malloc_failed] ; rdi = invalid_param
    call puts wrt ..plt
    mov rax, 0 ; return false
    jmp cleanup

no_find:
    mov rax, 0 ; return false
    jmp cleanup

end:
    mov [r13], rdi ; pos.x = i
    mov [r13 + 8], rsi ; pos.y = j
    mov rax, 1 ; return true
    jmp cleanup

cleanup:
    
    movsd xmm15 [rsp + 48]
    movsd xmm14 [rsp + 40]
    movsd xmm13 [rsp + 32]
    add rsp, 56 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
