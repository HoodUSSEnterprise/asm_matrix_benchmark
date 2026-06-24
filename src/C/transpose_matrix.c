/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 15:42:46
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 16:02:35
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
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check m->data
    if (m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
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

/***********************************************************
@description: transpose the matrix float
@param {MatrixFloat} *m
@return {*}
************************************************************/
MatrixFloat *transpose_matrix_float(MatrixFloat *m)
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
    // malloc res matrix
    MatrixFloat *res = NULL;
    res = (MatrixFloat *)malloc(sizeof(MatrixFloat));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = m->cols;
    res->cols = m->rows;
    // malloc for res->data
    res->data = (float *)malloc(sizeof(float) * res->rows * res->cols);
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

/***********************************************************
@description: transpose the matrix
@param {MatrixInt} *m
@return {*}
*************************************************************/
MatrixDouble *transpose_matrix_double(MatrixDouble *m)
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
    // malloc res matrix
    MatrixDouble *res = NULL;
    res = (MatrixDouble *)malloc(sizeof(MatrixDouble));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = m->cols;
    res->cols = m->rows;
    // malloc for res->data
    res->data = (double *)malloc(sizeof(double) * res->rows * res->cols);
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