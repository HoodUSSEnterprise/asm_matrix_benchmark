;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-21 12:46:43
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-21 12:46:59
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\inv_matrix_int.asm
; @Description: invertible matrix int nasm code on windows
;-------------------------------------------------------------
global inv_matrix_int

extern printf
extern puts

section .rodata
    

section .text

inv_matrix_int:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32 ; allocate shadow space for printf


cleanup:
    add rsp, 32 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    ret