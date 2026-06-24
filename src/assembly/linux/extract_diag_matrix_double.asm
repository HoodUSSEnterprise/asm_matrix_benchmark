;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:31:52
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:32:52
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\extract_diag_matrix_double.asm
; @Description: get diagonal element for matrix double, get the element which row index equal to col index.
;-------------------------------------------------------------

global extract_diag_double

extern malloc
extern free
extern printf
extern puts

section .rodata
    invalid_param db "Invalid param!", 10, 0                                   ; invalid param msg
    malloc_failed db "Memory allocation failed", 10, 0                         ; malloc failed msg

section .text

; double *extract_diag_double(MatrixDouble *m)
; rdi = m (System V)
extract_diag_double:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32 ; allocate shadow space for printf

    mov r14, rdi ; r14 = m

    ; check m
    test r14, r14
    jz null_ptr

    ; check m->data
    mov r14, [rdi]
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rdi

    mov r8, [r14 + 8]  ; r8 = m->rows
    mov r9, [r14 + 16] ; r9 = m->cols

    ; choose smaller one
    cmp r8, r9      ; m->rows < m->cols ?
    jae r8_bigger
    mov rdi, r8
    jmp next
r8_bigger:
    mov rdi, r9
    jmp next

next:
    ; malloc for res data, double type, len = rdi
    mov rcx, rdi ; rcx = rdi
    shl rcx, 3   ; rcx *= 8
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_pint

    mov rbx, rax  ; rbx = new data

    ; init loop
    xor rcx, rcx ; i = 0
    mov r9, [r14 + 16] ; r9 = m->cols
    mov r10, [r14]     ; r10 = m->data

loop1:
    cmp rcx, rdi  ; i < data->len?
    jge end

    ; data[i] = m->data[i * m->cols + i]
    mov r8, rcx ; r8 = i
    imul r8, r9 ; r8 *= m->cols
    add r8, rcx ; r8 += i

    movsd xmm0, [r10 + r8 * 8] ; xmm0 = m->data[i * m->cols + i]
    movsd [rbx + rcx * 8], xmm0 ; data[i] = m->data[i * m->cols + i]

    inc rcx ; i++
    jmp loop1

end:
    mov rax, rbx
    jmp cleanup

null_ptr:
    lea rdi, [rel invalid_param] ; rdi = invalid_param
    xor eax, eax
    call printf wrt ..plt
    mov rax, 0 ; return NULL
    jmp cleanup

malloc_fail_pint:
    lea rdi, [rel malloc_failed]
    call puts wrt ..plt
    mov rax, 0
    jmp cleanup

cleanup:
    add rsp, 32 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
