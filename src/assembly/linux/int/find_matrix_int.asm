; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-20 16:10:25
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:19:43
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\int\find_matrix_int.asm
; @Description: find elem position in matrix nasm code on linux
; -------------------------------------------------------------

global find_elem_int
extern puts
extern malloc

section .rodata
    invalid_param  db  "Invalid param!", 0              ; invalid param msg
    malloc_failed  db  "Memory allocation failed", 0    ; malloc failed msg

section .text

; bool find_elem_int(MatrixInt *m, int elem, Point *pos);
; rdi = m, rsi = elem, rdx = pos (System V)

find_elem_int:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for puts

    mov r14, rdi                        ; r14 = m
    mov r15d, esi                       ; r15d = elem
    mov r13, rdx                        ; r13 = pos

    ; check m
    test r14, r14
    jz null_ptr

    mov r14, [rdi]                      ; r14 = m->data

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
    xor rdi, rdi                        ; i = 0
    ; xor rsi, rsi ; j = 0
    mov r8, [r14 + 8]                   ; m->rows
    mov r9, [r14 + 16]                  ; m->cols
    mov r11, [r14]

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

        cmp [r11 + r10 * 4], r15d
        je end
        inc rsi                         ; j++
        jmp loop2

inc_rdi:
    inc rdi                             ; i++
    jmp loop1

null_ptr:
    lea rdi, [rel invalid_param]        ; rdi = invalid_param
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0                          ; return NULL
    jmp cleanup

malloc_fail:
    lea rdi, [rel malloc_failed]        ; rdi = invalid_param
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0                          ; return NULL
    jmp cleanup

no_find:
    mov rax, 0                          ; return false
    jmp cleanup

end:
    mov [r13], rdi                      ; pos.x = rdi
    mov [r13 + 8], rsi                  ; pos.y=rsi
    mov rax, 1                          ; return true
    jmp cleanup

cleanup:
    add rsp, 32                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
