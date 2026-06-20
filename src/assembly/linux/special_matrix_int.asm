;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-20 16:34:28
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-20 16:46:35
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\special_matrix_int.asm
; @Description: Special matrix helpers (System V x86-64, NASM)
; identity_matrix_int, diag_matrix_int, eye_matrix_int, zero_matrix_int
;-------------------------------------------------------------

global identity_matrix_int, diag_matrix_int, eye_matrix_int, zero_matrix_int
extern malloc
extern free
extern puts
extern memset

section .rodata
    malloc_failed db "Memory allocation failed", 0
    invalid_param db "Invalid param!", 0

section .text

; ---------------------------------------------------------------------------------------------
; MatrixInt *identity_matrix_int(int order);
; edi = order
; ---------------------------------------------------------------------------------------------
identity_matrix_int:
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14d, edi            ; r14 = order (32-bit)
    cmp r14d, 0
    jle id_null 

    ; malloc struct
    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz id_malloc_fail
    mov rbx, rax


    ; count = order * order
    mov r11d, r14d
    imul r11d, r14d           ; r11 = count

    ; malloc data (count * 4)
    mov rdi, r11
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz id_malloc_fail_data
    mov r12, rax

    ; memset(data, 0, count*4)
    mov rdi, r12
    mov esi, 0
    mov rdx, r11
    shl rdx, 2
    call memset wrt ..plt

    mov [rbx], r12
    mov dword [rbx + 8], r14d
    mov dword [rbx + 16], r14d

    xor r13d, r13d           ; i = 0
id_loop:
    cmp r13d, r14d
    jge id_end
    mov eax, r13d
    imul eax, r14d
    add eax, r13d
    mov dword [r12 + rax*4], 1
    inc r13d
    jmp id_loop

id_end:
    mov rax, rbx
    jmp id_cleanup

id_malloc_fail_data:
    lea rdi, [rel malloc_failed]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp id_cleanup

id_malloc_fail:
    lea rdi, [rel malloc_failed]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0
    jmp id_cleanup

id_null :
    lea rdi, [rel invalid_param]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0

id_cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

; ---------------------------------------------------------------------------------------------
; MatrixInt *diag_matrix_int(int *data, size_t len);
; rdi = data, rsi = len
; ---------------------------------------------------------------------------------------------
diag_matrix_int:
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14, rdi    ; r14 = data
    mov r15, rsi    ; r15 = len
    test r14, r14
    jz diag_null
    cmp r15, 0
    jle diag_null

    mov r11, r15
    imul r11, r15    ; r11 = len*len

    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz diag_malloc_fail
    mov rbx, rax

    mov rdi, r11
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz diag_malloc_fail_data
    mov r12, rax

    mov rdi, r12
    mov esi, 0
    mov rdx, r11
    shl rdx, 2
    call memset wrt ..plt

    mov [rbx], r12
    mov qword [rbx + 8], r15
    mov qword [rbx + 16], r15

    xor r13, r13
diag_loop:
    cmp r13, r11
    jge diag_end
    mov rax, r13
    imul rax, r15
    add rax, r13
    mov edx, [r14 + r13*4]
    mov [r12 + rax*4], edx
    inc r13
    jmp diag_loop

diag_end:
    mov rax, rbx
    jmp diag_cleanup

diag_malloc_fail_data:
    lea rdi, [rel malloc_failed]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp diag_cleanup

diag_malloc_fail:
    lea rdi, [rel malloc_failed]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0
    jmp diag_cleanup

diag_null:
    lea rdi, [rel invalid_param]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0

diag_cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

; ---------------------------------------------------------------------------------------------
; MatrixInt *eye_matrix_int(int rows, int cols);
; rdi = rows, rsi = cols
; ---------------------------------------------------------------------------------------------
eye_matrix_int:
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14d, edi
    mov r15d, esi
    cmp r14d, 0
    jle eye_null
    cmp r15d, 0
    jle eye_null

    mov r11d, r14d
    imul r11d, r15d    ; r11 = rows*cols

    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz eye_malloc_fail
    mov rbx, rax

    mov rdi, r11
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz eye_malloc_fail_data
    mov r12, rax

    mov rdi, r12
    mov esi, 0
    mov rdx, r11
    shl rdx, 2
    call memset wrt ..plt

    mov [rbx], r12
    mov dword [rbx + 8], r14d
    mov dword [rbx + 16], r15d

    ; set diagonal up to min(rows,cols)
    cmp r14d, r15d
    jge eye_min_row
    mov r9d, r14d
    jmp eye_setup
eye_min_row:
    mov r9d, r15d
eye_setup:
    xor r13d, r13d
eye_loop:
    cmp r13d, r9d
    jge eye_done
    mov eax, r13d
    imul eax, r15d
    add eax, r13d
    mov dword [r12 + rax*4], 1
    inc r13d
    jmp eye_loop
eye_done:
    mov rax, rbx
    jmp eye_cleanup

eye_malloc_fail_data:
    lea rdi, [rel malloc_failed]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp eye_cleanup

eye_malloc_fail:
    lea rdi, [rel malloc_failed]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0
    jmp eye_cleanup

eye_null:
    lea rdi, [rel invalid_param]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0

eye_cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret

; ---------------------------------------------------------------------------------------------
; MatrixInt *zero_matrix_int(int rows, int cols);
; rdi = rows, rsi = cols
; ---------------------------------------------------------------------------------------------
zero_matrix_int:
    push rbx
    push r12
    push r13
    push r14
    push r15
    sub rsp, 32

    mov r14d, edi
    mov r15d, esi
    cmp r14d, 0
    jle zero_null
    cmp r15d, 0
    jle zero_null

    mov r11d, r14d
    imul r11d, r15d

    mov rdi, 24
    call malloc wrt ..plt
    test rax, rax
    jz zero_malloc_fail
    mov rbx, rax

    mov rdi, r11
    shl rdi, 2
    call malloc wrt ..plt
    test rax, rax
    jz zero_malloc_fail_data
    mov r12, rax

    mov rdi, r12
    mov esi, 0
    mov rdx, r11
    shl rdx, 2
    call memset wrt ..plt

    mov [rbx], r12
    mov dword [rbx + 8], r14d
    mov dword [rbx + 16], r15d
    mov rax, rbx
    jmp zero_cleanup

zero_malloc_fail_data:
    lea rdi, [rel malloc_failed]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rdi, rbx
    call free wrt ..plt
    mov rax, 0
    jmp zero_cleanup

zero_malloc_fail:
    lea rdi, [rel malloc_failed]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0
    jmp zero_cleanup

zero_null:
    lea rdi, [rel invalid_param]
    sub rsp, 8
    call puts wrt ..plt
    add rsp, 8
    mov rax, 0

zero_cleanup:
    add rsp, 32
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret
