;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:41:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:42:28
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\random_matrix_float.asm
; @Description: random matrix float nasm code on linux
;-------------------------------------------------------------

global random_matrix_float

extern malloc
extern free
extern puts
extern srand
extern rand
extern time

section .rodata
    malloc_failed db "Memory allocation failed", 0
    invalid_param db "Invalid param!", 0
    rand_max dd 32767.0

section .text

; ---------------------------------------------------------------------------------------------
; MatrixFloat *random_matrix_float(size_t rows, size_t cols, float *range, size_t size);
; rdi = rows, rsi = cols, rdx = range, rcx = size (System V)
; ---------------------------------------------------------------------------------------------
random_matrix_float:

    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 48

    mov r14, rdi
    mov r15, rsi
    mov r12, rdx
    mov r13, rcx

    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    cmp r13, 0
    je case_size_zero
    cmp r13, 1
    je case_size_one
    jmp case_size_else

case_size_zero:
    mov dword [rsp + 32], 0x41200000
    mov dword [rsp + 36], 0
    jmp boundary_done

case_size_one:
    movss xmm0, [r12]
    xorps xmm1, xmm1
    comiss xmm0, xmm1
    jbe range_le_zero

    movss [rsp + 32], xmm0
    mov dword [rsp + 36], 0
    jmp boundary_done

range_le_zero:
    comiss xmm0, xmm1
    jb range_neg

    mov dword [rsp + 32], 0x41200000
    mov dword [rsp + 36], 0
    jmp boundary_done

range_neg:
    mov dword [rsp + 32], 0
    movss [rsp + 36], xmm0
    jmp boundary_done

case_size_else:
    movss xmm0, [r12]
    movss xmm1, [r12 + 4]
    comiss xmm0, xmm1
    jae first_bigger

    movss [rsp + 32], xmm1
    movss [rsp + 36], xmm0
    jmp boundary_done

first_bigger:
    movss [rsp + 32], xmm0
    movss [rsp + 36], xmm1

boundary_done:
    xor rdi, rdi
    call time wrt ..plt
    mov edi, eax
    call srand wrt ..plt

    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    mov rdi, r14
    imul rdi, r15

    lea rcx, [rdi * 4]
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax
    mov [rbx + 8], r14
    mov [rbx + 16], r15

    mov r15, [rbx]
    movss xmm14, [rsp + 32]
    movss xmm13, [rsp + 36]
    subss xmm14, xmm13
    movss xmm12, [rel rand_max]

    xor r14, r14

fill_loop:
    cmp r14, rdi
    jge end

    call rand wrt ..plt
    cvtsi2ss xmm0, eax
    divss xmm0, xmm12
    mulss xmm0, xmm14
    addss xmm0, xmm13

    movss [r15 + r14 * 4], xmm0
    inc r14
    jmp fill_loop

malloc_fail_struct:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

end:
    mov rax, rbx

cleanup:
    add rsp, 48
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
