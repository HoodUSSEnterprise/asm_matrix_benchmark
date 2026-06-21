/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-21 14:13:48
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-21 16:01:43
@FilePath: \asm_matrix_benchmark\src\C\lu_matrix.c
@Description: lu decomposition of matrix c code
*************************************************************/
#include "lu_matrix.h"

/***********************************************************
@description: lu decomposition of matrix
@param {MatrixInt} *m
@param {LU_Result} *res
@return {*}
 ************************************************************/
bool LU_Decomposition_int(MatrixInt *m, LU_Result *res)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check dimension
    if (m->cols != m->rows)
    {
        puts("It's not a square");
        return false;
    }
    // check the matrix can lu decomposition or not
    Leading_Minors_Int *leading_minors = get_leading_minors_int(m);
    if (leading_minors == NULL)
    {
        fprintf(stderr, "function get_leading_minors_int has a wrong value\n");
        return NULL;
    }
    for (size_t i = 0; i < leading_minors->len; i++)
    {
        int rank = 0;
        if (rank_matrix_int(leading_minors->matrix_data + i, &rank) == false)
        {
            return false;
        }
        else
        {
            if ((size_t)rank != m->cols)
            {
                fprintf(stderr, "This matrix can't lu decomposition\n");
                return false;
            }
        }
    }

    // malloc new L
    MatrixDouble *L = NULL;
    L = (MatrixDouble *)malloc(sizeof(MatrixDouble));
    if (L == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return false;
    }
    L->rows = m->rows;
    L->cols = m->cols;
    // malloc new L data
    L->data = (double *)malloc(sizeof(double) * L->rows * L->cols);
    if (L->data == NULL)
    {
        free(L);
        fprintf(stderr, "Memory allocation failed\n");
        return false;
    }
    // malloc new U
    MatrixDouble *U = NULL;
    U = (MatrixDouble *)malloc(sizeof(MatrixDouble));
    if (U == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return false;
    }
    U->rows = m->rows;
    U->cols = m->cols;
    // malloc new U data
    U->data = (double *)malloc(sizeof(double) * U->rows * U->cols);
    if (U->data == NULL)
    {
        free(U);
        fprintf(stderr, "Memory allocation failed\n");
        return false;
    }
    // malloc new res
    if (res == NULL)
    {
        res = (LU_Result *)malloc(sizeof(LU_Result));
        if (res == NULL)
        {
            fprintf(stderr, "Memory allocation failed\n");
            return false;
        }
    }

    // calc L
    // init L matrix upper triangle
    for (size_t i = 0; i < L->rows; i++)
    {
        L->data[i * L->cols + i] = 1;
        for (size_t j = i + 1; j < L->cols; j++)
        {
            L->data[i * L->cols + j] = 0;
        }
    }

    // calc U
    // init U matrix lower triangle
    for (size_t i = 0; i < U->cols; i++)
    {
        U->data[i] = m->data[i];
    }
    for (size_t i = 0; i < U->rows; i++)
    {
        for (size_t j = 0; j < i; j++)
        {
            U->data[i * U->cols + j] = 0;
        }
    }

    // final result
    res->L = L;
    res->U = U;
    return true;
}