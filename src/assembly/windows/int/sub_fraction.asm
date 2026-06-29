; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-28 15:55:06
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-29 09:24:22
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\int\sub_fraction.asm
; @Description: sub fraction nasm code on windows
; -------------------------------------------------------------

global sub_fraction

extern gcd

section .text

; Fraction sub_fraction(Fraction *f1, Fraction *f2);
; rcx = f1, rdx = f2

sub_fraction:

    ; save callee_register
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space

    mov r12, rcx                        ; r12 = f1
    mov r13, rdx                        ; r13 = f2

    mov r14d, [r12]                     ; r14d = f1->x
    imul r14d, [r13 + 4]                ; r14d *= f2->y
    mov r15d, [r13]                     ; r15d = f2->x
    imul r15d, [r12 + 4]                ; r15d *= f1->y

    sub r14d, r15d                      ; up = f1->x * f2->y - f2->x * f1->y

    mov r15d, [r12 + 4]                 ; r15d = f1->y
    imul r15d, [r13 + 4]                ; r15d *= f2->y

    mov ecx, r14d
    mov edx, r15d
    call gcd

    mov r10d, eax                       ; r10d = gcd

    mov eax, r14d                       ; up
    cdq
    idiv r10d                           ; eax = up / gcd

    mov r14d, eax

    mov eax, r15d                       ; down
    cdq
    idiv r10d                           ; eax = down / gcd

    mov r15d, eax

    ; normalize sign: denominator should be positive
    cmp r15d, 0
    jge positive
    neg r14d
    neg r15d

positive:

    ; pack return value: rax = (y << 32) | x
    mov rax, r14                        ; low 32 = numerator (x)
    shl r15, 32                         ; high 32 = denominator (y)
    or rax, r15

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
