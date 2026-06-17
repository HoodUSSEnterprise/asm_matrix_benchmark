/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 15:42:46
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-17 15:48:15
@FilePath: \asm_matrix_benchmark\src\C\transpose_matrix.c
@Description: transpose the matrix c code
*************************************************************/
#include "transpose_matrix.h"

/***********************************************************
@description: transpose the matrix
@param {MatrixInt} *m
@return {*}
 ************************************************************/
MatrixInt *transpose_matrix_int(MatrixInt *m)
{
    // check m
    if (m == NULL)
    {
        puts("Invalid param!");
        return NULL;
    }
    // check m->data
    if (m->data == NULL)
    {
        puts("Invalid param!");
        return NULL;
    }
    // malloc res matrix
    MatrixInt *res = NULL;
    res = (MatrixInt *)malloc(sizeof(MatrixInt));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = m->cols;
    res->cols = m->rows;
    // malloc for res->data
    res->data = (int *)malloc(sizeof(int) * res->rows * res->cols);
    if (res->data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // transpose means res->data[i][j] = m->data[j][i];
    // that is res->data[i * res->cols + j] = m->data[j * m->cols + i]
    for (size_t i = 0; i < res->rows; i++)
    {
        for (size_t j = 0; j < res->cols; j++)
        {
            res->data[i * res->cols + j] = m->data[j * m->cols + i];
        }
    }
    return res;
}