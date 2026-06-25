;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:33:14
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-24 20:33:29
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\random_matrix_double.asm
; @Description: random matrix double nasm code on linux
;-------------------------------------------------------------

global random_matrix_double

extern malloc
extern free
extern puts
extern srand
extern rand
extern time

section .rodata
    malloc_failed db "Memory allocation failed", 0                         ; malloc failed msg
    invalid_param db "Invalid param!", 0                                   ; invalid param msg
    dq_10_0 dq 10.0
    dq_0_0 dq 0.0
    dq_1_0 dq 1.0
    dq_0_5 dq 0.5

section .text

; ---------------------------------------------------------------------------------------------
; MatrixDouble *random_matrix_double(size_t rows, size_t cols, double *range, size_t size);
; rdi = rows, rsi = cols, rdx = range, rcx = size (System V)
; ---------------------------------------------------------------------------------------------
random_matrix_double:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 48

    mov r14, rdi ; r14 = rows
    mov r15, rsi ; r15 = cols
    mov r12, rdx ; r12 = range
    mov r13, rcx ; r13 = size

    ; check param rows
    test r14, r14
    jz null_ptr
    ; check param cols
    test r15, r15
    jz null_ptr

    ; determine max_boundary and min_boundary
    ; store on stack: [rsp + 32] = max, [rsp + 40] = min
    cmp r13, 0
    je case_size_zero
    cmp r13, 1
    je case_size_one
    jmp case_size_else

case_size_zero:
    movsd xmm0, [rel dq_10_0] ; max = 10.0
    movsd xmm1, [rel dq_0_0]  ; min = 0.0
    movsd [rsp + 32], xmm0
    movsd [rsp + 40], xmm1
    jmp boundary_done

case_size_one:
    movsd xmm0, [r12]      ; xmm0 = range[0]
    movsd xmm1, [rel dq_0_0] ; xmm1 = 0.0
    comisd xmm0, xmm1
    ja range_pos
    je range_zero
    ; range[0] < 0
    movsd xmm1, [rel dq_0_0] ; max = 0.0
    movsd [rsp + 32], xmm1
    movsd [rsp + 40], xmm0  ; min = range[0]
    jmp boundary_done

range_pos:
    movsd [rsp + 32], xmm0      ; max = range[0]
    movsd xmm1, [rel dq_0_0]
    movsd [rsp + 40], xmm1     ; min = 0.0
    jmp boundary_done

range_zero:
    movsd xmm0, [rel dq_10_0] ; max = 10.0
    movsd xmm1, [rel dq_0_0]  ; min = 0.0
    movsd [rsp + 32], xmm0
    movsd [rsp + 40], xmm1
    jmp boundary_done

case_size_else:
    movsd xmm0, [r12]      ; xmm0 = range[0]
    movsd xmm1, [r12 + 8]  ; xmm1 = range[1]
    comisd xmm0, xmm1
    jae first_bigger

    ; range[0] < range[1]
    movsd [rsp + 32], xmm1      ; max = range[1]
    movsd [rsp + 40], xmm0      ; min = range[0]
    jmp boundary_done

first_bigger:
    movsd [rsp + 32], xmm0      ; max = range[0]
    movsd [rsp + 40], xmm1      ; min = range[1]

boundary_done:
    ; srand((unsigned)time(NULL))
    xor rdi, rdi
    call time wrt ..plt
    mov edi, eax
    call srand wrt ..plt

    ; malloc res struct (24 bytes)
    mov edi, 24
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_struct

    mov rbx, rax ; rbx = res

    ; total elements = rows * cols
    mov rdi, r14
    imul rdi, r15 ; rdi = rows * cols
    mov r12, rdi  ; preserve count

    ; malloc res->data
    lea rcx, [rdi * 8]
    mov rdi, rcx
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    ; init res fields
    mov [rbx], rax      ; res->data = new malloc data
    mov [rbx + 8], r14  ; res->rows = rows
    mov [rbx + 16], r15 ; res->cols = cols

    ; fill data with random values
    mov r15, [rbx]      ; r15 = res->data
    movsd xmm14, [rsp + 32]; xmm14 = max_boundary
    movsd xmm15, [rsp + 40]; xmm15 = min_boundary
    subsd xmm14, xmm15      ; xmm14 = max - min

    xor r14, r14        ; i = 0

fill_loop:
    cmp r14, r12        ; i < total elements
    jge end

    call rand wrt ..plt
    ; convert to double: scale = (double)rand() / RAND_MAX
    cvtsi2sd xmm0, eax
    mov rax, 2147483647 ; RAND_MAX = 0x7FFFFFF
    cvtsi2sd xmm1, rax
    divsd xmm0, xmm1   ; xmm0 = (double)rand() / RAND_MAX
    mulsd xmm0, xmm14  ; xmm0 *= (max - min)
    addsd xmm0, xmm15  ; xmm0 += min

    movsd [r15 + r14 * 8], xmm0 ; res->data[i] = value
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
    mov rax, 0 ; return NULL
    jmp cleanup

end:
    mov rax, rbx

cleanup:
    add rsp, 48 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
