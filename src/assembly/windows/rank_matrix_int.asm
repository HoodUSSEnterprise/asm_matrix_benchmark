;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-18 23:25:45
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-19 23:42:49
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\rank_matrix_int.asm
; @Description: rank matrix int nasm code on windows
;-------------------------------------------------------------
global rank_matrix_int
extern puts
extern malloc

section .rodata
    epsilon dq 1e-6
    malloc_failed db "Memory allocation failed", 0                         ; malloc failed msg
    invalid_param db "Invalid param!", 0                                   ; invalid param msg

section .text

; bool rank_matrix_int(MatrixInt *m, int *rank)
; rcx = m, rdx = rank
rank_matrix_int:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32 ; allocate shadow space for printf

    mov r14, rcx ; r14 = m
    mov r15, rdx ; r15 = rank

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rcx] ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    ; check dimension
    mov r8, [r14 + 8]   ; m->rows
    mov r9, [r14 + 16]  ; m->cols

    cmp r9, 0  ; m->rows == 0
    je null_ptr
    cmp r9, 0  ; m->cols == 0
    je null_ptr

    ; malloc new data, because elimination use exsits floating-point numbers
    mov rdi, [r14 + 16] ; rdi = m->cols
    imul rdi, [r14 + 8] ; rdi *= m->rows
    ; now rdi is len of new data array
    ; new data array type is double
    mov rcx, rdi  ; rcx = len of array
    shl rcx, 3    ; rcx *= 8
    call malloc
    test rax, rax
    jz malloc_fail_data
    
    ; save malloc res data
    mov rbx, rax   ; rbx = data

    ; init loop
    mov r12, [r14] ; r12 = m->data
    mov r8, [r14 + 8] ; r8 = m->rows
    mov r9, [r14 + 16] ; r9 = m->cols
    xor rcx, rcx ; rows = 0
    xor rdx, rdx ; cols = 0

loop1:
    cmp rcx, r8 ; rows < m->rows
    jge calc_rank

    ; find main element
    mov r11, rcx ; r11 = pivot
    find_pivot:
        cmp r11, r8  ; r11 < m->rows
        jge col_zero

        ; calculate offset: data[pivot * m->cols + cols]
        mov rax, r11        ; rax = pivot
        imul rax, r9        ; rax = pivot * m->cols
        add rax, rdx        ; rax = pivot * m->cols + cols
        
        ; load value and take absolute value
        movsd xmm0, [r12 + rax * 8]   ; xmm0 = data[pivot * cols + cols]
        ; fabs: clear sign bit
        mov r13, 0x7FFFFFFFFFFFFFFF
        movq xmm1, r13
        andps xmm0, xmm1          ; xmm0 = fabs(value)

        ; compare fabs(value) < 1e-6
        movsd xmm2, [rel epsilon]     ; xmm2 = 1e-6
        comisd xmm0, xmm2
        jb pivot_zero              ; if fabs(value) < epsilon, try next row

    pivot_zero:
        inc r11                    ; pivot++
        jmp find_pivot

    col_zero:
        inc rdx ; cols++
        jmp loop1


calc_rank:


loop_copy:
    cmp rdx, rdi  ; i < m->rows * m->cols
    jge next

    movsxd rax, [r12 + rdx * 4] ; expand int(4 bytes) to 8 bytes
    cvtsi2sd xmm0, rax          ; transfer to double
    movsd [rbx + rdx * 8], xmm0 ; data[i] = m->data[i] * 1.0;

    inc rdx ; i++
    jmp loop_copy

next:
    ; this part is guass elimination
    ; r12 = m->data

null_ptr:
    lea rcx, [rel invalid_param] ; rcx = invalid_param
    call puts
    mov rax, 0 ; return false
    jmp cleanup

malloc_fail_data:
    lea rcx, [rel malloc_failed] ; rcx = malloc_failed
    call puts
    mov rax, 0
    jmp cleanup

cleanup:
    add rsp, 32 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rdi
    pop rbx
    ret