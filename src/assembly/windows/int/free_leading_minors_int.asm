; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-26 19:23:17
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 19:23:23
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\int\free_leading_minors_int.asm
; @Description: free leading minors int nasm code
; -------------------------------------------------------------
global free_leading_minors_int

extern printf
extern puts

section .rodata

section .data

section .text

free_leading_minors_int:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

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
