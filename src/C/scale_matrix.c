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
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check m->data
    if (m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
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

/***********************************************************
@description: scale matrix float
@param {MatrixFloat} *m
@param {float} scale
@return {*}
************************************************************/
MatrixFloat *scale_matrix_float(MatrixFloat *m, float scale)
{
    // check m
    if (m == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check m->data
    if (m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // malloc for new res
    MatrixFloat *res = NULL;
    res = (MatrixFloat *)malloc(sizeof(MatrixFloat));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->cols = m->cols;
    res->rows = m->rows;
    // malloc for res->data
    res->data = (float *)malloc(sizeof(float) * res->cols * res->rows);
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