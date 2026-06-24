;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:41:23
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:43:02
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\extract_diag_matrix_float.asm
; @Description:get diagonal element for matrix float nasm code on linux 
;-------------------------------------------------------------

global extract_diag_float

extern malloc
extern free
extern printf
extern puts

section .rodata
    invalid_param db "Invalid param!", 10, 0
    malloc_failed db "Memory allocation failed", 10, 0

section .text

; float *extract_diag_float(MatrixFloat *m)
; rdi = m (System V)
extract_diag_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi

    test r14, r14
    jz null_ptr

    mov r14, [rdi]
    test r14, r14
    jz null_ptr

    mov r14, rdi

    mov r8, [r14 + 8]
    mov r9, [r14 + 16]

    cmp r8, r9
    jae r8_bigger
    mov rdi, r8
    jmp next
r8_bigger:
    mov rdi, r9
    jmp next

next:
    mov r12, rdi        ; r12 = diag_len (callee-saved)
    shl rdi, 2          ; rdi = byte size
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_pint

    mov rbx, rax

    xor rcx, rcx
    mov r9, [r14 + 16]
    mov r10, [r14]

loop1:
    cmp rcx, r12
    jge end

    mov r8, rcx
    imul r8, r9
    add r8, rcx

    movss xmm0, [r10 + r8 * 4]
    movss [rbx + rcx * 4], xmm0

    inc rcx
    jmp loop1

end:
    mov rax, rbx
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_pint:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
