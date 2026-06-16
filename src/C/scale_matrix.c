/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:12:24
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:15:26
@FilePath: \asm_matrix_benchmark\src\C\scale_matrix.c
@Description: scale matrix c code
*************************************************************/
#include "scale_matrix.h"

/***********************************************************
@description: scale matrix
@param {MatrixInt} *m
@param {int} scale
@return {*}
 ************************************************************/
MatrixInt *scale_matrix_int(MatrixInt *m, int scale)
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
    // malloc for new res
    MatrixInt *res = NULL;
    res = (MatrixInt *)malloc(sizeof(MatrixInt));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->cols = m->cols;
    res->rows = m->rows;
    // malloc for res->data
    res->data = (int *)malloc(sizeof(int) * res->cols * res->rows);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    for (size_t i = 0; i < res->cols * res->rows; i++)
    {
        res->data[i] = m->data[i] * scale;
    }
    return res;
}