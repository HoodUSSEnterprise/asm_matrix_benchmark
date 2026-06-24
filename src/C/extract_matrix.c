/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-20 15:41:14
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 13:32:38
@FilePath: \asm_matrix_benchmark\src\C\extract_matrix.c
@Description: extract matrix c code
*************************************************************/

#include "extract_matrix.h"

/***********************************************************
@description: extract matrix's row
@param {MatrixInt} *m
@param {size_t} index
@return {*}
 ************************************************************/
MatrixInt *extract_row_int(MatrixInt *m, size_t index)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check index, index must in range 0 and m->rows - 1
    if (index > m->rows - 1)
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
    res->rows = 1;
    // malloc for res->data
    res->data = (int *)malloc(sizeof(int) * res->cols);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    for (size_t i = 0; i < m->cols; i++)
    {
        res->data[i] = m->data[index * m->cols + i];
    }
    return res;
}

/***********************************************************
@description: extract matrix's col
@param {MatrixInt} *m
@param {size_t} index
@return {*}
 ************************************************************/
MatrixInt *extract_col_int(MatrixInt *m, size_t index)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check index, index must in range 0 and m->cols - 1
    if (index > m->cols - 1)
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
    res->rows = m->rows;
    res->cols = 1;
    // malloc for res->data
    res->data = (int *)malloc(sizeof(int) * res->rows);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    for (size_t i = 0; i < m->rows; i++)
    {
        res->data[i] = m->data[i * m->cols + index];
    }
    return res;
}

/***********************************************************
@description: extract matrix's diag, that means the number which row index equals to col index
@param {MatrixInt} *m
@return {*}
 ************************************************************/
int *extract_diag_int(MatrixInt *m)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    size_t data_len = (m->rows >= m->cols ? m->cols : m->rows);
    int *data = (int *)malloc(sizeof(int) * data_len);
    if (data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    for (size_t i = 0; i < data_len; i++)
    {
        data[i] = m->data[i * m->cols + i];
    }
    return data;
}

/***********************************************************
@description: extract matrix's row float
@param {MatrixFloat} *m
@param {size_t} index
@return {*}
************************************************************/
MatrixFloat *extract_row_float(MatrixFloat *m, size_t index)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check index, index must in range 0 and m->rows - 1
    if (index > m->rows - 1)
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
    res->rows = 1;
    // malloc for res->data
    res->data = (float *)malloc(sizeof(float) * res->cols);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    for (size_t i = 0; i < m->cols; i++)
    {
        res->data[i] = m->data[index * m->cols + i];
    }
    return res;
}

/***********************************************************
@description: extract matrix's col float
@param {MatrixFloat} *m
@param {size_t} index
@return {*}
************************************************************/
MatrixFloat *extract_col_float(MatrixFloat *m, size_t index)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check index, index must in range 0 and m->cols - 1
    if (index > m->cols - 1)
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
    res->rows = m->rows;
    res->cols = 1;
    // malloc for res->data
    res->data = (float *)malloc(sizeof(float) * res->rows);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    for (size_t i = 0; i < m->rows; i++)
    {
        res->data[i] = m->data[i * m->cols + index];
    }
    return res;
}

/***********************************************************
@description: extract matrix's diag float
@param {MatrixFloat} *m
@return {*}
************************************************************/
float *extract_diag_float(MatrixFloat *m)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    size_t data_len = (m->rows >= m->cols ? m->cols : m->rows);
    float *data = (float *)malloc(sizeof(float) * data_len);
    if (data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    for (size_t i = 0; i < data_len; i++)
    {
        data[i] = m->data[i * m->cols + i];
    }
    return data;
}
