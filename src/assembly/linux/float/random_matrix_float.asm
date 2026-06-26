; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 20:41:55
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-26 15:17:45
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\float\random_matrix_float.asm
; @Description: random matrix float nasm code on linux
; -------------------------------------------------------------

global random_matrix_float

extern malloc
extern free
extern puts
extern srand
extern rand
extern time

section .rodata
    malloc_failed  db  "Memory allocation failed", 0
    invalid_param  db  "Invalid param!", 0
    rand_max       dd  0x4f000000

section .text

; ---------------------------------------------------------------------------------------------
; MatrixFloat *random_matrix_float(size_t rows, size_t cols, float *range, size_t size);
; rdi = rows, rsi = cols, rdx = range, rcx = size (System V)
; ---------------------------------------------------------------------------------------------

random_matrix_float:

    ; save callee_register
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 56

    movss [rsp + 40], xmm12
    movss [rsp + 44], xmm13
    movss [rsp + 48], xmm14

    mov r14, rdi                        ; r14 = rows
    mov r15, rsi                        ; r15 = cols
    mov r12, rdx                        ; r12 = range
    mov r13, rcx                        ; r13 = size

    ; check param rows
    test r14, r14
    jz null_ptr
    ; check param cols
    test r15, r15
    jz null_ptr

    ; determine max_boundary and min_boundary
    ; store on stack: [rsp + 32] = max, [rsp + 36] = min
    cmp r13, 0
    je case_size_zero
    cmp r13, 1
    je case_size_one
    jmp case_size_else

case_size_zero:
    mov dword[rsp + 32], 0x41200000
    mov dword[rsp + 36], 0
    jmp boundary_done

case_size_one:
    movss xmm0, [r12]
    xorps xmm1, xmm1
    comiss xmm0, xmm1
    jbe range_le_zero

    ; range[0] > 0
    movss [rsp + 32], xmm0
    mov dword[rsp + 36], 0
    jmp boundary_done

range_le_zero:
    comiss xmm0, xmm1
    jb range_neg

    ; range[0] == 0
    mov dword[rsp + 32], 0x41200000     ; max = 10.0f
    mov dword[rsp + 36], 0              ; min = 0.0f
    jmp boundary_done

range_neg:
    ; range[0] < 0
    mov dword[rsp + 32], 0
    movss [rsp + 36], xmm0
    jmp boundary_done

case_size_else:
    movss xmm0, [r12]
    movss xmm1, [r12 + 4]
    comiss xmm0, xmm1
    jae first_bigger

    ; range[0] < range[1]
    movss [rsp + 32], xmm1              ; max = range[1]
    movss [rsp + 36], xmm0              ; min = range[0]
    jmp boundary_done

first_bigger:
    movss [rsp + 32], xmm0
    movss [rsp + 36], xmm1

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

    mov rbx, rax

    ; total elements = rows * cols
    mov rdi, r14
    imul rdi, r15                       ; rdi = rows * cols
    mov r12, rdi                        ; preserve element count
    shl rdi, 2                          ; rdi = byte size (sizeof(float) = 4)
    ; malloc res->data
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    ; init res fields
    mov [rbx], rax                      ; res->data = new malloc data
    mov [rbx + 8], r14                  ; res->rows = rows
    mov [rbx + 16], r15                 ; res->cols = cols

    ; fill data with random float values
    mov r15, [rbx]                      ; r15 = res->data
    movss xmm14, [rsp + 32]
    movss xmm13, [rsp + 36]
    subss xmm14, xmm13
    movss xmm12, [rel rand_max]

    xor r14, r14                        ; i = 0

fill_loop:
    cmp r14, r12                        ; i < total elements
    jge end

    call rand wrt ..plt
    cvtsi2ss xmm0, eax                  ; xmm0 = (float)rand()
    divss xmm0, xmm12                   ; xmm0 = (float)rand() / RAND_MAX  [0, 1)
    mulss xmm0, xmm14                   ; xmm0 *= (max - min)
    addss xmm0, xmm13                   ; xmm0 += min

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
    movss xmm14, [rsp + 48]
    movss xmm13, [rsp + 44]
    movss xmm12, [rsp + 40]
    add rsp, 56
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
