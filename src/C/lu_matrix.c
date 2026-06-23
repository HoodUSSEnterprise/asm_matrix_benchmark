/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-21 14:13:48
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 16:59:31
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
            if ((size_t)rank != i + 1)
            {
                fprintf(stderr, "This matrix can't lu decomposition\n");
                return false;
            }
        }
    }

    // free leading_minors
    for (size_t i = 0; i < leading_minors->len; i++)
    {
        free((leading_minors->matrix_data + i)->data);
    }
    free(leading_minors->matrix_data);
    free(leading_minors);

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

    // The specific process of LU decomposition is as follows:
    /*
    |a_{11} & a_{12} & a_{13} & \cdots & a_{1n}|
    |a_{21} & a_{22} & a_{23} & \cdots & a_{2n}|
    |a_{31} & a_{32} & a_{33} & \cdots & a_{3n}|
    |\vdots & \vdots & \vdots & \ddots & \vdots|
    |a_{n1} & a_{n2} & a_{n3} & \cdots & a_{nn}|

    =

    |1      &        &        &        &       |
    |l_{21} & 1      &        &        &       |
    |l_{31} & l_{32} & 1      &        &       |
    |\vdots & \vdots & \vdots & \ddots &       |
    |l_{n1} & l_{n2} & l_{n3} & \cdots & 1     |

    \*

    |u_{11} & u_{12} & u_{13} & \cdots & u_{1n}|
    |       & u_{22} & u_{23} & \cdots & u_{2n}|
    |       &        & u_{33} & \cdots & u_{3n}|
    |       &        &        & \ddots & \vdots|
    |       &        &        &        & u_{nn}|
    */

    // From matrix multiplication, we obtain:
    // init L matrix upper triangle
    for (size_t i = 0; i < L->rows; i++)
    {
        for (size_t j = i; j < L->cols; j++)
        {
            L->data[i * L->cols + j] = (i == j ? 1.0 : 0.0);
        }
    }

    // init U matrix lower triangle
    for (size_t i = 0; i < U->rows; i++)
    {
        for (size_t j = 0; j < i; j++)
        {
            U->data[i * U->cols + j] = 0.0;
        }
    }

    /*
    u_{1j} = a_{1j},  j = 1:n
    l_{i1} = a_{i1} / u_{11},  i = 2:n
    */
    for (size_t i = 0; i < U->cols; i++)
    {
        U->data[i] = m->data[i];
    }
    for (size_t i = 1; i < L->rows; i++)
    {
        L->data[i * L->cols + 0] = m->data[i * m->cols + 0] / U->data[0 * U->cols + 0];
    }

    /*
    u_{ij} = a_{ij} - sum_{k=1}^{i-1} l_{ik} u_{kj},  j = i:n
    l_{ij} = (a_{ij} - sum_{k=1}^{j-1} l_{ik} u_{kj}) / u_{jj},  i = j+1:n
    */
    for (size_t i = 1; i < L->rows; i++)
    {
        for (size_t j = i; j < L->rows; j++)
        {
            double sum = 0;
            for (size_t k = 0; k < i; k++)
            {
                sum += (L->data[i * L->cols + k] * U->data[k * U->cols + j]);
            }
            U->data[i * U->cols + j] = m->data[i * m->cols + j] - sum;
        }
        for (size_t j = i + 1; j < L->rows; j++)
        {
            double sum = 0;
            for (size_t k = 0; k < j; k++)
            {
                sum += (L->data[j * L->cols + k] * U->data[k * U->cols + i]);
            }
            L->data[j * L->cols + i] = (m->data[j * m->cols + i] - sum) / U->data[i * U->cols + i];
        }
    }
    // final result
    res->L = L;
    res->U = U;
    return true;
}