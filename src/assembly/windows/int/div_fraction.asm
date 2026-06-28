; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-28 15:55:07
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-28 15:56:41
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\int\div_fraction.asm
; @Description: div fraction nasm code on windows
; -------------------------------------------------------------

global div_fraction

extern gcd

section .text

; Fraction div_fraction(Fraction *f1, Fraction *f2);
; rcx = f1, rdx = f2

div_fraction:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space

    mov r12, rcx                        ; r12 = f1
    mov r13, rdx                        ; r13 = f2

    mov r14d, [r12]                     ; r14d = f1->x
    imul r14d, [r13 + 4]                ; r14d *= f2->y (up)

    mov r15d, [r12 + 4]                 ; r15d = f1->y
    imul r15d, [r13]                    ; r15d *= f2->x (down)

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
    pop rdi
    pop rbx
    ret
