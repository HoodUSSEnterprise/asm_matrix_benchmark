; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 18:52:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:21:45
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\float\find_matrix_float.asm
; @Description:  find elem position in matrix float nasm code on windows
; -------------------------------------------------------------

global find_elem_float
extern puts
extern malloc

section .rodata
    invalid_param  db  "Invalid param!", 0                               ; invalid param msg
    malloc_failed  db  "Memory allocation failed", 0                     ; malloc failed msg
    epsilon        dd  1e-6
    abs_mask       dd  0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF, 0x7FFFFFFF

section .text

; bool find_elem_float(MatrixFloat *m, float elem, Point *pos);
; rcx = m, xmm1 = elem, r8 = pos

find_elem_float:

    ; save callee_register
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 48                         ; allocate shadow space for puts

    movss [rsp + 36], xmm13
    movss [rsp + 40], xmm14
    movss [rsp + 44], xmm15

    mov r14, rcx                        ; r14 = m
    movss xmm15, xmm1                   ; xmm15 = elem
    mov r13, r8                         ; r13 = pos

    ; check m
    test r14, r14
    jz null_ptr

    mov r14, [rcx]                      ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

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
    mov rcx, 16
    call malloc
    test rax, rax
    jz malloc_fail
    mov r13, rax

init_loop:
    ; init loop condition
    xor rdi, rdi                        ; i = 0
    mov r8, [r14 + 8]                   ; m->rows
    mov r9, [r14 + 16]                  ; m->cols
    mov r11, [r14]
    movss xmm14, [rel epsilon]          ; xmm14 = 1e-6f
    movd xmm13, [rel abs_mask]

loop1:
    cmp rdi, r8                         ; i < m->rows
    jge no_find
    xor rsi, rsi

    loop2:
        cmp rsi, r9                     ; j < m->cols
        jge inc_rdi

        mov r10, r9                     ; r10 = m->cols
        imul r10, rdi                   ; r10 *= i
        add r10, rsi                    ; r10 += j

        ; compare m->data[i * m->cols + j] with elem using epsilon
        movss xmm0, [r11 + r10 * 4]     ; xmm0 = m->data[i * m->cols + j]
        subss xmm0, xmm15               ; xmm0 = value - elem
        ; fabs: clear sign bit
        andps xmm0, xmm13               ; xmm0 = fabs(value - elem)
        comiss xmm0, xmm14              ; compare with epsilon
        jb end                          ; if fabs < epsilon, found
        inc rsi                         ; j++
        jmp loop2

inc_rdi:
    inc rdi                             ; i++
    jmp loop1

null_ptr:
    lea rcx, [rel invalid_param]        ; rcx = invalid_param
    call puts
    mov rax, 0                          ; return false
    jmp cleanup

malloc_fail:
    lea rcx, [rel malloc_failed]        ; rcx = invalid_param
    call puts
    mov rax, 0                          ; return false
    jmp cleanup

no_find:
    mov rax, 0                          ; return false
    jmp cleanup

end:
    mov [r13], rdi                      ; pos.x = i
    mov [r13 + 8], rsi                  ; pos.y = j
    mov rax, 1                          ; return true
    jmp cleanup

cleanup:

    movss xmm15, [rsp + 44]
    movss xmm14, [rsp + 40]
    movss xmm13, [rsp + 36]
    add rsp, 48                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret
