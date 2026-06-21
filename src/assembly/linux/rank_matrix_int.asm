;-------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-20 16:10:25
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-21 10:06:43
; @FilePath: \asm_matrix_benchmark\src\assembly\linux\rank_matrix_int.asm
; @Description: rank matrix int nasm code on linux
;-------------------------------------------------------------

global rank_matrix_int
extern puts
extern printf
extern malloc
extern free

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
    push r12
    push r13
    push r14
    push r15
    sub rsp, 40 ; allocate shadow space for printf

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

    cmp r8, 0  ; m->rows == 0
    je null_ptr
    cmp r9, 0  ; m->cols == 0
    je null_ptr

    ; malloc new data, because elimination use exists floating-point numbers
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
    mov r12, [r14] ; r12 = m->data

    xor rdx, rdx ; i = 0

loop_copy:
    cmp rdx, rdi  ; i < m->rows * m->cols
    jge next

    movsxd rax, [r12 + rdx * 4] ; expand int(4 bytes) to 8 bytes
    cvtsi2sd xmm0, rax          ; transfer to double
    movsd [rbx + rdx * 8], xmm0 ; data[i] = m->data[i] * 1.0;

    inc rdx ; i++
    jmp loop_copy

next:
    ; this part is gauss elimination
    ; r12 = new data
    ; init loop
    mov r12, rbx ; r12 = new data
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

        ; found non-zero pivot
        jmp pivot_found

    pivot_zero:
        inc r11                    ; pivot++
        jmp find_pivot

    col_zero:
        inc rdx ; cols++
        jmp loop1
    
    pivot_found:
        ; check if row swap needed
        cmp r11, rcx               ; pivot != rows?
        je no_swap

        ; swap rows: pivot <-> rows
        xor r13, r13              ; j = 0
        
    swap_loop:
        cmp r13, r9                ; j < m->cols?
        jge no_swap
        
        ; calculate offsets
        mov rax, r11               ; rax = pivot
        imul rax, r9               ; rax = pivot * m->cols
        add rax, r13               ; rax = pivot * m->cols + j
        shl rax, 3                 ; byte offset
        
        mov rbx, rcx               ; rbx = rows
        imul rbx, r9               ; rbx = rows * m->cols
        add rbx, r13               ; rbx = rows * m->cols + j
        shl rbx, 3                 ; byte offset
        
        ; swap data[pivot][j] and data[rows][j]
        movsd xmm0, [r12 + rax]    ; temp = data[pivot][j]
        movsd xmm1, [r12 + rbx]    ; xmm1 = data[rows][j]
        movsd [r12 + rax], xmm1    ; data[pivot][j] = data[rows][j]
        movsd [r12 + rbx], xmm0    ; data[rows][j] = temp
        
        inc r13
        jmp swap_loop

    no_swap:
        ; elimination below pivot row
        mov r13, rcx               ; r13 = rows
        inc r13                    ; r13 = i = rows + 1

    elim_outer:
        cmp r13, r8                ; i < rows?
        jge elim_done
        
        ; calculate factor = data[i][cols] / data[rows][cols]
        ; offset for data[rows][cols]
        mov rax, rcx               ; rax = rows
        imul rax, r9               ; rax = rows * m->cols
        add rax, rdx               ; rax = rows * m->cols + cols
        shl rax, 3                 ; byte offset
        movsd xmm0, [r12 + rax]    ; xmm0 = data[rows][cols]
        
        ; offset for data[i][cols]
        mov rbx, r13               ; rbx = i
        imul rbx, r9               ; rbx = i * m->cols
        add rbx, rdx               ; rbx = i * m->cols + cols
        shl rbx, 3                 ; byte offset
        movsd xmm1, [r12 + rbx]    ; xmm1 = data[i][cols]
        
        divsd xmm1, xmm0           ; xmm1 = factor
        
        ; inner loop: j = cols to m->cols-1
        mov r10, rdx               ; r10 = j = cols

        elim_inner:
            cmp r10, r9                ; j < m->cols?
            jge elim_inner_done
            
            ; data[i][j] -= factor * data[rows][j]
            ; offset for data[rows][j]
            mov rax, rcx               ; rax = rows
            imul rax, r9               ; rax = rows * m->cols
            add rax, r10               ; rax = rows * m->cols + j
            shl rax, 3                 ; byte offset
            movsd xmm2, [r12 + rax]    ; xmm2 = data[rows][j]
            mulsd xmm2, xmm1           ; xmm2 = factor * data[rows][j]
            
            ; offset for data[i][j]
            mov rbx, r13               ; rbx = i
            imul rbx, r9               ; rbx = i * m->cols
            add rbx, r10               ; rbx = i * m->cols + j
            shl rbx, 3                 ; byte offset
            movsd xmm3, [r12 + rbx]    ; xmm3 = data[i][j]
            subsd xmm3, xmm2           ; xmm3 = data[i][j] - factor * data[rows][j]
            movsd [r12 + rbx], xmm3    ; store result
            
            inc r10 ; j++
            jmp elim_inner

    elim_inner_done:
        inc r13                    ; i++
        jmp elim_outer

elim_done:
    inc rcx                    ; rows++
    inc rdx                    ; cols++
    jmp loop1

calc_rank:
    
    ; init loop
    ; r12 = m->data
    ; r8 = m->rows
    ; r9 = m->cols
    xor rcx, rcx ; i = 0
    ; xor rdx. rdx ; j = 0

    xor esi, esi  ; calc non zero lines

loop_calc_rank1:
    cmp rcx, r8 ; i < m->rows ?
    jge end
    xor rdx, rdx ; j = 0
    loop_calc_rank2:
        cmp rdx, r9 ; j < m->cols
        jge inc_rcx_calc_rank

        mov rax, rcx ; rax = i
        imul rax, r9 ; rax *= m->cols
        add rax, rdx ; rax += j

        ; load value and take absolute value
        movsd xmm0, [r12 + rax * 8]   ; xmm0 = data[i * m->cols + j]
        ; fabs: clear sign bit
        mov r13, 0x7FFFFFFFFFFFFFFF
        movq xmm1, r13
        andps xmm0, xmm1          ; xmm0 = fabs(value)

        ; compare fabs(value) < 1e-6
        movsd xmm2, [rel epsilon]     ; xmm2 = 1e-6
        comisd xmm0, xmm2
        jnb is_not_zero              ; if fabs(value) >= 1e-6, try next row
        inc rdx ; j++
        jmp loop_calc_rank2

    is_not_zero:
        inc esi ; rank++
        inc rcx ; i++
        jmp loop_calc_rank1

inc_rcx_calc_rank:
    inc rcx ; i++
    jmp loop_calc_rank1


null_ptr:
    lea rcx, [rel invalid_param] ; rcx = invalid_param
    call puts
    mov rax, 0 ; return false
    jmp cleanup

malloc_fail_data:
    lea rcx, [rel malloc_failed] ; rcx = malloc_failed
    call puts
    mov rax, 0 ; return false
    jmp cleanup

end:
    mov rcx, r12 ; free new data
    call free
    mov dword [r15], esi
    mov rax, 1 ; return true
    jmp cleanup

cleanup:
    add rsp, 40 ; restore stack pointer
    ; restore callee_register
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbx
    ret