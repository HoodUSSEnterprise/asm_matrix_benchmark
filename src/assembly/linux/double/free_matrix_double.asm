; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-26 19:23:49
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 19:50:09
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\double\free_matrix_double.asm
; @Description: free matrix double nasm code
; -------------------------------------------------------------

global free_matrix_double

extern printf
extern puts

section .rodata

section .data

section .text

free_matrix_double:

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
