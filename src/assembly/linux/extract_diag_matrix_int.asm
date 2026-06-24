;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 21:02:07
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 21:02:25
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\extract_diag_matrix_int.asm
; @Description: get diagonal element for matrix, this method is like eye matrix.It means we get the element which row index equal to col index.
;-------------------------------------------------------------

global extract_diag_int

extern malloc
extern free
extern printf
extern puts

section .rodata
    invalid_param db "Invalid param!", 10, 0
    malloc_failed db "Memory allocation failed", 10, 0

section .text

; int *extract_diag_int(MatrixInt *m)
; rdi = m (System V)
extract_diag_int:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

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
    ; malloc for res data, int type, len = rdi
    mov rcx, rdi
    shl rcx, 2   ; rcx *= 4 (sizeof int)
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_pint

    mov rbx, rax  ; rbx = new data

    ; init loop
    ; for get diagonal element
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

    mov r11d, [r10 + r8 * 4] ; r11d = m->data[i * m->cols + i]
    mov [rbx + rcx * 4], r11d ; data[i] = m->data[i * m->cols + i]

    inc rcx ; i++
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
