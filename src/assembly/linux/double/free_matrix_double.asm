; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-26 19:23:49
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-27 09:59:18
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\double\free_matrix_double.asm
; @Description: free matrix double nasm code
; -------------------------------------------------------------

global free_matrix_double

extern free
extern puts

section .rodata
    invalid_param  db  "Invalid param!", 0    ; invalid param msg

section .text

; void free_matrix_double(MatrixDouble **m);
; rdi = m

free_matrix_double:

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
    call free

    ; free *m
    mov rdi, r14                        ; rdi = *m
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
    pop rbx
    ret
