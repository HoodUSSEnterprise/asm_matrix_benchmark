; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-28 13:05:14
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-28 13:11:15
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\int\gcd.asm
; @Description: calc greatest common divisor of x and y, use the non-recursive form of the Euclidean algorithm
; -------------------------------------------------------------

global gcd

section .text

; int gcd(int x, int y);
; ecx = x, edx = y

gcd:

    ; save callee_register
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space

    mov r12d, ecx                       ; r12d = x
    mov r13d, edx                       ; r13d = y

loop1:
    cmp r13d, 0
    je end

    mov eax, r12d                       ; eax = x
    cdq                                 ; sign-extend eax to edx:eax
    idiv r13d                           ; eax = x / y, edx = x % y

    mov r12d, r13d
    mov r13d, edx
    jmp loop1

end:
    mov eax, r12d
    jmp cleanup

cleanup:
    add rsp, 32                         ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret
