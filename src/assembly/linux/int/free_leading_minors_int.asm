; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-26 19:23:17
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-27 10:02:18
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\int\free_leading_minors_int.asm
; @Description: free leading minors int nasm code
; -------------------------------------------------------------

global free_leading_minors_int

extern free
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 0    ; invalid param msg

section .text

; void free_leading_minors_int(Leading_Minors_Int **l);
; rdi = l

free_leading_minors_int:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    ; check l
    mov r14, rdi                        ; r14 = l
    test r14, r14
    jz null_ptr

    ; check *l
    mov r14, [rdi]                      ; r14 = *l
    test r14, r14
    jz null_ptr

    ; init loop, free Leading_Minors_Int->matrix_data;
    ; typedef struct Leading_Minors_Int
    ; {
    ;     MatrixInt *matrix_data;
    ;     size_t len;
    ; } Leading_Minors_Int;
    xor r12, r12                        ; i = 0
    mov r13, [r14 + 8]                  ; r13 = len
    mov r15, [r14]                      ; r15 = (*l)->matrix_data

loop1:
    cmp r12, r13                        ; i < len ?
    jae next

    ; r15 = matrix_data
    mov rax, r12                        ; rax = i
    imul rax, 24                        ; rax *= 24
    mov rdi, [r15 + rax]                ; rdi = (*l)->matrix_data[i].data
    call free wrt ..plt

    inc r12
    jmp loop1

next:
    ; free (*l)->matrix_data
    mov rdi, r15
    call free wrt ..plt

    ; free *l
    mov rdi, r14
    call free wrt ..plt

    ; optional, *m = NULL
    ; To avoid dangling pointers, I assign NULL here
    mov r14, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]        ; rdi = invalid_param
    call puts wrt ..plt
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
