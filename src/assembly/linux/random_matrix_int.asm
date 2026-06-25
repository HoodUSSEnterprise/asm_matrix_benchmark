;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-24 09:34:52
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-25 09:23:29
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\random_matrix_int.asm
; @Description:random matrix nasm code on linux 
;-------------------------------------------------------------

global random_matrix_int

extern malloc
extern free
extern puts
extern srand
extern rand
extern time

section .rodata
    malloc_failed db "Memory allocation failed", 0                         ; malloc failed msg
    invalid_param db "Invalid param!", 0                                   ; invalid param msg

section .text

; ---------------------------------------------------------------------------------------------
; MatrixInt *random_matrix_int(size_t rows, size_t cols, int *range, size_t size);
; rdi = rows, rsi = cols, rdx = range, rcx = size
; ---------------------------------------------------------------------------------------------
random_matrix_int:

    ; save callee_register
    push rbx
    push rdi
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
    ; store on stack: [rsp + 32] = max, [rsp + 36] = min
    cmp r13, 0
    je case_size_zero
    cmp r13, 1
    je case_size_one
    jmp case_size_else

case_size_zero:
    mov dword [rsp + 32], 10  ; max = 10
    mov dword [rsp + 36], 0 ; min = 0
    jmp boundary_done

case_size_one:
    mov eax, [r12]      ; eax = range[0]
    test eax, eax
    jg range_pos
    je range_zero
    ; range[0] < 0
    mov dword [rsp + 32], 0  ; max = 0
    mov [rsp + 36], eax  ; min = range[0]
    jmp boundary_done

range_pos:
    mov [rsp + 32], eax      ; max = range[0]
    mov dword [rsp + 36], 0 ; min = 0
    jmp boundary_done

range_zero:
    mov dword [rsp + 32], 10 ; max = 10
    mov dword [rsp + 36], 0 ; min = 0
    jmp boundary_done

case_size_else:
    mov eax, [r12]      ; eax = range[0]
    mov edx, [r12 + 4]  ; edx = range[1]
    cmp eax, edx
    jge first_bigger

    ; range[0] < range[1]
    mov [rsp + 32], edx      ; max = range[1]
    mov [rsp + 36], eax  ; min = range[0]
    jmp boundary_done

first_bigger:
    mov [rsp + 32], eax      ; max = range[0]
    mov [rsp + 36], edx  ; min = range[1]

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
    mov r11, r14
    imul r11, r15 ; r11 = rows * cols

    ; malloc res->data
    lea rdi, [r11 * 4]
    call malloc wrt ..plt
    test rax, rax
    jz malloc_fail_data

    ; init res fields
    mov [rbx], rax      ; res->data = new malloc data
    mov [rbx + 8], r14  ; res->rows = rows
    mov [rbx + 16], r15 ; res->cols = cols

    ; fill data with random values
    mov r15, [rbx]      ; r15 = res->data
    mov r12d, [rsp + 32]     ; r12d = max_boundary
    mov r13d, [rsp + 36] ; r13d = min_boundary
    sub r12d, r13d      ; r12d = max - min
    inc r12d            ; r12d = range_size = max - min + 1

    xor r14, r14        ; i = 0

fill_loop:
    cmp r14, r11        ; i < total elements
    jge end

    call rand wrt ..plt
    xor edx, edx
    div r12d            ; edx = rand() % range_size
    add edx, r13d       ; edx = rand() % range_size + min

    mov [r15 + r14 * 4], edx ; res->data[i] = value
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
    pop rdi
    pop rbx
    ret
