; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-26 17:32:01
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 19:50:48
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\int\free_matrix_int.asm
; @Description: free matrix nasm c code
; -------------------------------------------------------------

global free_matrix_int

extern printf
extern puts

section .rodata

section .data

section .text

free_matrix_int:

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
