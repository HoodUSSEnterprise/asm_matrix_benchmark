; -------------------------------------------------------------
; @Author: HoodUSSEnterprise
; @Date: 2026-06-28
; @LastEditors: HoodUSSEnterprise
; @LastEditTime: 2026-06-29 08:52:57
; @FilePath: \asm_matrix_benchmark\src\assembly\windows\int\determinant_matrix_int.asm
; @Description: determinant matrix int nasm code on windows
; use Fraction arithmetic for exact integer determinant
; -------------------------------------------------------------

global determinant_int
extern puts
extern malloc
extern free
extern add_fraction
extern sub_fraction
extern mul_fraction
extern div_fraction

section .rodata
    epsilon        dq  1e-6
    malloc_failed  db  "Memory allocation failed", 0
    invalid_param  db  "Invalid param!", 0
    not_square     db  "It's not a square", 0

section .text

; bool determinant_int(MatrixInt *m, int *det)
; rcx = m, rdx = det

determinant_int:

    ; save callee_register
    push rbx
    push rdi
    push rsi
    push r12
    push r13
    push r14
    push r15
    sub rsp, 64                         ; 32 shadow space + 32 for factor + temp

    mov r15, rdx                        ; r15 = det
    mov r14, rcx                        ; r14 = m

    ; check param m
    test r14, r14
    jz null_ptr

    mov r14, [rcx]                      ; r14 = m->data

    ; check m->data
    test r14, r14
    jz null_ptr

    ; restore r14
    mov r14, rcx

    ; check dimension
    mov r13, [r14 + 8]                  ; r13 = m->rows
    mov r12, [r14 + 16]                 ; r12 = m->cols

    cmp r13, 0
    je null_ptr
    cmp r12, 0
    je null_ptr

    ; check square matrix
    cmp r13, r12
    jne not_a_square

    ; malloc Fraction array (8 bytes per element)
    mov rcx, r13
    imul rcx, r12
    mov r11, rcx                        ; r11 = element count
    shl rcx, 3                          ; rcx *= 8
    call malloc
    test rax, rax
    jz malloc_fail_data

    mov rbx, rax                        ; rbx = data (Fraction*)

    ; copy m->data to data as Fractions {x, 1}
    xor rcx, rcx                        ; i = 0
    mov rsi, [r14]                      ; rsi = m->data (int*)

loop_copy:
    cmp rcx, r11                        ; i < element count?
    jge copied

    mov eax, [rsi + rcx * 4]            ; eax = m->data[i]
    mov [rbx + rcx * 8], eax            ; data[i].x = m->data[i]
    mov dword[rbx + rcx * 8 + 4], 1     ; data[i].y = 1

    inc rcx
    jmp loop_copy

copied:
    ; rbx = data (Fraction*)
    ; r13 = m->rows
    ; r12 = m->cols
    ; r11 = element count (preserved for free later)

    ; Gaussian elimination using fraction arithmetic
    xor rsi, rsi                        ; rows = 0
    xor rdi, rdi                        ; cols = 0

loop1:
    cmp rsi, r13                        ; rows < m->rows?
    jge calc_det
    cmp rdi, r12                        ; cols < m->cols?
    jge calc_det

    ; find main element
    mov r8, rsi                         ; r8 = pivot = rows

find_pivot:
    cmp r8, r13                         ; pivot < m->rows?
    jge col_zero

    ; check fabs(data[pivot][cols].x / data[pivot][cols].y) < epsilon
    mov rax, r8
    imul rax, r12
    add rax, rdi                        ; rax = pivot * cols + cols

    movsxd rcx, [rbx + rax * 8]         ; rcx = x (sign-extended)
    cvtsi2sd xmm0, rcx
    movsxd rcx, [rbx + rax * 8 + 4]     ; rcx = y (sign-extended)
    cvtsi2sd xmm1, rcx
    divsd xmm0, xmm1                    ; xmm0 = x / y

    ; fabs
    mov rcx, 0x7FFFFFFFFFFFFFFF
    movq xmm1, rcx
    andps xmm0, xmm1                    ; xmm0 = fabs(x/y)

    movsd xmm2, [rel epsilon]
    comisd xmm0, xmm2
    jb pivot_zero                       ; near zero, skip

    jmp pivot_found

    pivot_zero:
        inc r8
        jmp find_pivot

    col_zero:
        mov dword[r15], 0               ; *det = 0
        mov r14d, 1                     ; return true
        jmp free_and_cleanup

    pivot_found:
        ; check if row swap needed
        cmp r8, rsi
        je no_swap

        ; swap rows: pivot <-> rows
        xor r9, r9                      ; j = 0

    swap_loop:
        cmp r9, r12                     ; j < m->cols?
        jge no_swap

        ; offset_pivot = pivot * cols + j
        mov rax, r8
        imul rax, r12
        add rax, r9
        shl rax, 3

        ; offset_rows = rows * cols + j
        mov rcx, rsi
        imul rcx, r12
        add rcx, r9
        shl rcx, 3

        ; swap 8-byte Fraction
        mov rdx, [rbx + rax]            ; temp = data[pivot][j]
        mov r10, [rbx + rcx]            ; r10 = data[rows][j]
        mov [rbx + rax], r10            ; data[pivot][j] = data[rows][j]
        mov [rbx + rcx], rdx            ; data[rows][j] = temp

        inc r9
        jmp swap_loop

    no_swap:
        ; elimination below pivot row
        mov r9, rsi                     ; r9 = i = rows + 1
        inc r9

    elim_outer:
        cmp r9, r13                     ; i < m->rows?
        jge elim_done

        ; factor = div_fraction(&data[i][cols], &data[rows][cols])
        ; &data[i][cols] = rbx + (i * cols + cols) * 8
        mov rax, r9
        imul rax, r12
        add rax, rdi
        shl rax, 3
        lea rcx, [rbx + rax]            ; rcx = &data[i][cols]

        ; &data[rows][cols] = rbx + (rows * cols + cols) * 8
        mov rax, rsi
        imul rax, r12
        add rax, rdi
        shl rax, 3
        lea rdx, [rbx + rax]            ; rdx = &data[rows][cols]

        call div_fraction               ; rax = factor (packed Fraction)

        ; save factor on stack [rsp+32..39]
        mov [rsp + 32], eax             ; factor.x
        shr rax, 32
        mov [rsp + 36], eax             ; factor.y

        ; inner loop: j = cols to m->cols-1
        mov r10, rdi                    ; r10 = j = cols

        elim_inner:
            cmp r10, r12                ; j < m->cols?
            jge elim_inner_done

            ; temp = mul_fraction(&factor, &data[rows][j])
            lea rcx, [rsp + 32]         ; &factor
            ; &data[rows][j] = rbx + (rows * cols + j) * 8
            mov rax, rsi
            imul rax, r12
            add rax, r10
            shl rax, 3
            lea rdx, [rbx + rax]        ; &data[rows][j]

            call mul_fraction           ; rax = temp (packed Fraction)

            ; save temp on stack [rsp+48..55]
            mov [rsp + 48], eax         ; temp.x
            shr rax, 32
            mov [rsp + 52], eax         ; temp.y

            ; data[i][j] = sub_fraction(&data[i][j], &temp)
            ; &data[i][j] = rbx + (i * cols + j) * 8
            mov r9, rsi                 ; r9 = i = rows + 1
            inc r9
            mov rax, r9
            imul rax, r12
            add rax, r10
            shl rax, 3
            lea rcx, [rbx + rax]        ; &data[i][j]

            lea rdx, [rsp + 48]         ; &temp

            call sub_fraction           ; rax = result (packed Fraction)

            ; store result back to data[i][j], using saved return value
            ; rdi, rsi, rbx still intact (callee-saved)
            ; r9 = i, r10 = j (still intact)
            ; r12 = cols, r13 = rows

            ; offset = (i * cols + j) * 8
            mov r9, rsi                 ; r9 = i = rows + 1
            inc r9
            mov rdx, r9
            imul rdx, r12
            add rdx, r10
            shl rdx, 3

            mov [rbx + rdx], eax        ; data[i][j].x
            shr rax, 32
            mov [rbx + rdx + 4], eax    ; data[i][j].y

            inc r10                     ; j++
            jmp elim_inner

    elim_inner_done:
        inc r9                          ; i++
        jmp elim_outer

elim_done:
    inc rsi                             ; rows++
    inc rdi                             ; cols++
    jmp loop1

calc_det:
    ; multiply diagonal elements: res = {1,1}
    ; then res = mul_fraction(&res, &data[i][i]) for each i

    ; initialize res as Fraction {1,1} on stack
    mov dword[rsp + 48], 1              ; res.x = 1
    mov dword[rsp + 52], 1              ; res.y = 1

    xor r8, r8                          ; i = 0

det_mul_loop:
    cmp r8, r13                         ; i < m->rows?
    jge det_done

    ; res = mul_fraction(&res, &data[i][i])
    lea rcx, [rsp + 48]                 ; &res

    ; &data[i][i] = rbx + (i * cols + i) * 8
    mov rax, r8
    imul rax, r12
    add rax, r8
    shl rax, 3
    lea rdx, [rbx + rax]                ; &data[i][i]

    call mul_fraction

    ; store new res on stack for next iteration
    mov [rsp + 48], eax                 ; res.x
    shr rax, 32
    mov [rsp + 52], eax                 ; res.y

    inc r8
    jmp det_mul_loop

det_done:
    ; extract x (numerator) = determinant
    mov eax, [rsp + 48]                 ; eax = res.x
    mov [r15], eax                      ; *det = res.x

    mov r14d, 1                         ; return true
    jmp free_and_cleanup

null_ptr:
    lea rcx, [rel invalid_param]
    call puts
    mov rax, 0
    jmp cleanup

not_a_square:
    lea rcx, [rel not_square]
    call puts
    mov rax, 0
    jmp cleanup

malloc_fail_data:
    lea rcx, [rel malloc_failed]
    call puts
    mov rax, 0
    jmp cleanup

free_and_cleanup:
    mov rcx, rbx                        ; free data
    call free
    mov eax, r14d                       ; restore return value

cleanup:
    add rsp, 64
    pop r15
    pop r14
    pop r13
    pop r12
    pop rsi
    pop rdi
    pop rbx
    ret
