; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-28 15:55:05
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-28 15:56:52
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\int\add_fraction.asm
; @Description: add fraction nasm code on windows
; -------------------------------------------------------------

global add_fraction

extern gcd

section .text

; typedef struct Fraction
; {
;     int x;
;     int y;
; } Fraction;
; Fraction add_fraction(Fraction *f1, Fraction *f2);
; rcx = f1, rdx = f2

add_fraction:

    ; save callee_register
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32                         ; allocate shadow space for printf

    mov r12, rcx                        ; r12 = f1
    mov r13, rdx                        ; r13 = f2

    mov r14d, [r12]                     ; r14d = f1->x
    imul r14d, [r13 + 4]                ; r14d *= f2->y
    mov r15d, [r13]                     ; r15d = f2->x
    imul r15d, [r12 + 4]                ; r15d *= f1->y

    add r14d, r15d                      ; up = f1->x * f2->y + f2->x * f1->y

    mov r15d, [r12 + 4]                 ; r15d = f1->y
    imul r15d, [r13 + 4]                ; r15d *= f2->y

    mov ecx, r14d
    mov edx, r15d
    call gcd

    mov r10d, eax                       ; r10d = gcd

    mov eax, r14d                       ; up
    cdq
    idiv r10d

    mov r14d, eax

    mov eax, r15d                       ; down
    cdq
    idiv r10d

    mov r15d, eax

    ; normalize sign: denominator should be positive
    cmp r15d, 0
    jge positive
    neg r14d
    neg r15d

positive:

    ; pack return value: rax = (y << 32) | x
    mov rax, r14
    shl r15, 32
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
