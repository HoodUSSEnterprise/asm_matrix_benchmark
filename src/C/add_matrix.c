/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 18:54:52
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:23:22
@FilePath: \asm_matrix_benchmark\src\C\add_matrix.c
@Description: add matrix c code
*************************************************************/
#include "add_matrix.h"

/***********************************************************
@description: add matrix
@param {MatrixInt} *m1
@param {MatrixInt} *m2
@return {*}
 ************************************************************/
MatrixInt *add_matrix_int(MatrixInt *m1, MatrixInt *m2)
{
    // check m1 and m2
    if (m1 == NULL || m2 == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check m1->data and m2->data
    if (m1->data == NULL || m2->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check dimension
    if (m1->cols != m2->cols || m1->rows != m2->rows)
    {
        printf("Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)\n", m1->cols, m2->cols, m1->rows, m2->rows);
        return 0;
    }
    // malloc new res
    MatrixInt *res = NULL;
    res = (MatrixInt *)malloc(sizeof(MatrixInt));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = m1->rows;
    res->cols = m2->cols;
    // malloc for res->data
    res->data = (int *)malloc(sizeof(int) * m1->cols * m1->rows);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // give value
    for (size_t i = 0; i < m1->cols * m1->rows; i++)
    {
        res->data[i] = m1->data[i] + m2->data[i];
    }
    return res;
}