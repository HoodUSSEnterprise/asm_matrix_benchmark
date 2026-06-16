;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-16 16:47:06
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-16 18:41:57
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\mul_matrix_int.asm
; @Description: mul matrix nasm code on windows
;-------------------------------------------------------------

global mul_matrix_int
extern printf
extern malloc
extern free

section .rodata
    malloc_failed db "Memory allocation failed", 10, 0                         ; malloc failed msg
    invaild_param db "Invalid param!", 10, 0                                   ; invalid param msg
    dim_mismatch  db "Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)", 10, 0       ; dim mismatch msg

section .text

; MatrixInt *mul_matrix_int(MatrixInt *m1, MatrixInt *m2);
; rcx = m1, rdx = m2
mul_matrix_int:

    ; save callee_register
    push rbx
    push rdi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32 ; allocate shadow space for printf

    mov r14, rcx ; r14 = m1
    mov r15, rdx ; r15 = m2

    ; check param m1 and m2
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    mov r14, [rcx] ; r14 = m1->data
    mov r15, [rdx] ; r15 = m2->data

    ; check m1->data and m2->data
    test r14, r14
    jz null_ptr
    test r15, r15
    jz null_ptr

    ; restore r14 and r15
    mov r14, rcx
    mov r15, rdx

    ; check dimension
    mov r8, [r14 + 8]   ; m1->rows
    mov r9, [r14 + 16]  ; m1->cols
    mov r10, [r15 + 8]  ; m2->rows
    mov r11, [r15 + 16] ; m2->cols

    cmp r9, r10 ; m1->cols == m2->rows
    jne dimension_mismatch

    ; save the data len in rdi
    mov rdi, r8     ; rdi = m1->rows
    imul rdi, r11    ; rdi = m1->rows * m2->cols

    ; malloc res 24 bytes
    mov rcx, 24 
    call malloc
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax

    ; malloc res->data
    mov rcx, rdi
    shl rcx, 2 ; rcx *= 4
    call malloc
    test rax, rax
    jz malloc_fail_data

    mov [rbx], rax      ; res->data = new malloc data
    mov r9, [r14 + 8]  ; r9 = m1->rows
    mov r10, [r15 + 16]  ; r10 = m2->cols
    mov [rbx + 8], r9   ; res->rows = m1->rows
    mov [rbx + 16], r10 ; res->cols = m2->cols

    ; init loop condition
    xor rdi, rdi ; i = 0
    xor rsi, rsi ; j = 0
    xor r13, r13 ; k = 0
    mov rdx, [r14 + 16] ; rdx = m1->cols
    mov rcx, [r15 + 16] ; rcx = m2->cols
    mov r11, [rbx]

    ; after this we don't use r14 and r15, so we use r14 and r15 directly
    mov r14, [r14]
    mov r15, [r15]

loop1:
    cmp rdi, r9 ; i < result.rows
    jge end
    xor rsi, rsi
    loop2:
        cmp rsi, r10 ; j < result.cols
        jge inc_rdi
        mov eax, 0
        xor r13, r13 ; k = 0
        loop3:
            cmp r13, rdx ; k < m1->cols
            jge give_value

            ; calc first number
            mov r8, rdi ; r8 = i
            imul r8, rdx ; r8 *= m1->cols
            add r8, r13 ; r8 += k
            mov r12d, [r14 + r8 * 4] ; r9 = m1->data[i * m1->cols + k]
            
            ; calc second number
            mov r8, r13 ; r8 = k
            imul r8, rcx ; r8 *= m2->cols
            add r8, rsi ; r8 += j
            imul r12d, [r15 + r8 * 4] ; r9 *= m2->data[k * m1->cols + j]

            ; calc the sum
            add eax, r12d
            inc r13 ; k++
            jmp loop3
        
    give_value:
        ; calc index
        mov r8, rdi ; r8 = i
        imul r8, r10 ; r8 *= res->cols
        add r8, rsi ; r8 += j
        mov [r11 + r8 * 4], eax ; res->data[i * res->cols + j] = sum
        inc rsi ; j++
        jmp loop2

inc_rdi:
    inc rdi ; i++
    jmp loop1

malloc_fail_struct:
    lea rcx, [rel malloc_failed] ; rcx = malloc_failed
    call printf
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rcx, [rel malloc_failed] ; rcx = malloc_failed
    call printf
    mov rcx, rbx
    call free
    mov rax, 0
    jmp cleanup

null_ptr:
    lea rcx, [rel invaild_param] ; rcx = invaild_param
    call printf
    mov rax, 0 ; return NULL
    jmp cleanup

dimension_mismatch:
    lea rcx, [rel dim_mismatch] 
    mov rdx, [r14 + 8]          ; m1.rows
    mov r8, [r14 + 16]          ; m1.cols
    mov r9, [r15 + 8]           ; m2.rows
    mov r10, [r15 + 16]         ; m2.cols
    mov [rsp + 32], r10         ; fifth parament
    call printf
    mov rax, 0                  ; return NULL
    jmp cleanup

end:
    mov rax, rbx

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
    