; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-27 09:21:59
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-27 10:03:21
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\float\free_leading_minors_float.asm
; @Description: free leading minors float nasm code
; -------------------------------------------------------------

global free_leading_minors_float

extern free
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 0    ; invalid param msg

section .text

; void free_leading_minors_float(Leading_Minors_Float **l);
; rdi = l

free_leading_minors_float:

    ; save callee_register
    push rbx
    push rdi
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

    ; init loop, free Leading_Minors_Float->matrix_data;
    ; typedef struct Leading_Minors_Float
    ; {
    ;     MatrixFloat *matrix_data;
    ;     size_t len;
    ; } Leading_Minors_Float;
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
    call free

    inc r12
    jmp loop1

next:
    ; free (*l)->matrix_data
    mov rdi, r15
    call free

    ; free *l
    mov rdi, r14
    call free

    ; optional, *m = NULL
    ; To avoid dangling pointers, I assign NULL here
    mov r14, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]        ; rdi = invalid_param
    call puts
    jmp cleanup

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
