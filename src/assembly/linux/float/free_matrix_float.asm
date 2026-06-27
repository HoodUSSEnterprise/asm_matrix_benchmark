; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-27 09:20:31
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-27 10:09:25
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\float\free_matrix_float.asm
; @Description: free matrix float nasm code
; -------------------------------------------------------------

global free_matrix_float

extern free
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 0    ; invalid param msg

section .text

; void free_matrix_float(MatrixFloat **m);
; rdi = m

free_matrix_float:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    ; check m
    mov r14, rdi                        ; r14 = m
    test r14, r14
    jz null_ptr

    ; check *m
    mov r14, [rdi]                      ; r14 = *m
    test r14, r14
    jz null_ptr

    ; free (*m)->data
    mov rdi, [r14]                      ; rdi = (*m)->data
    call free wrt ..plt

    ; free *m
    mov rdi, r14                        ; rdi = *m
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
