; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-26 17:32:01
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-27 08:54:16
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\int\free_matrix_int.asm
; @Description: free matrix nasm c code
; -------------------------------------------------------------
global free_matrix_int

extern free
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 0    ; invalid param msg

section .text

; void free_matrix_int(MatrixInt **m);
; rcx = m

free_matrix_int:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    ; check m
    mov r14, rcx                        ; r14 = m
    test r14, r14
    jz null_ptr

    ; check *m
    mov r14, [rcx]                      ; r14 = *m
    test r14, r14
    jz null_ptr

    ; free (*m)->data
    mov rcx, [r14]                      ; rcx = (*m)->data
    call free

    ; free *m
    mov rcx, r14                        ; rcx = *m
    call free

    ; optional, *m = NULL
    ; To avoid dangling pointers, I assign NULL here
    mov r14, 0

null_ptr:
    lea rcx, [rel invalid_param]        ; rcx = invalid_param
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
