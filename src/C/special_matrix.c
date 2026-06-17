/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 17:22:56
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-17 17:42:23
@FilePath: \asm_matrix_benchmark\src\C\special_matrix.c
@Description: some special matrix like identity matrix, diag matrix, eye_matrix and zero matrix
*************************************************************/
#include "special_matrix.h"

/***********************************************************
@description: generator identity matrix, every element type is int
@param {int} order
@return {*}
 ************************************************************/
MatrixInt *identity_matrix_int(int order)
{
    // check order, order must be great than 0
    if (order <= 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // malloc res
    MatrixInt *res = NULL;
    res = (MatrixInt *)malloc(sizeof(MatrixInt));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = (size_t)order;
    res->cols = (size_t)order;
    // malloc res data
    res->data = (int *)malloc(sizeof(int) * order * order);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // init res->data with 0
    memset(res->data, 0, sizeof(int) * order * order);
    // diag must be 1
    for (size_t i = 0; i < order; i++)
    {
        res->data[i * order + i] = 1;
    }
    return res;
}

/***********************************************************
@description: generator diag matrix, every element type is int
@param {int} *data
@param {size_t} len
@return {*}
 ************************************************************/
MatrixInt *diag_matrix_int(int *data, size_t len)
{
    // check data and len
    if (data == NULL || len < 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // malloc res
    MatrixInt *res = NULL;
    res = (MatrixInt *)malloc(sizeof(MatrixInt));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = len;
    res->cols = len;
    // malloc res data
    res->data = (int *)malloc(sizeof(int) * len * len);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // init res->data with 0
    memset(res->data, 0, sizeof(int) * len * len);
    // diag must be 1
    for (size_t i = 0; i < len; i++)
    {
        res->data[i * len + i] = data[i];
    }
    return res;
}

/***********************************************************
@description: generator eye matrix, every element type is int
@param {int} rows
@param {int} cols
@return {*}
 ************************************************************/
MatrixInt *eye_matrix_int(int rows, int cols)
{
    // check rows and cols
    if (rows <= 0 || cols <= 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // calc eye matrix diag len
    int col = (rows >= cols ? cols : rows);
    // malloc res
    MatrixInt *res = NULL;
    res = (MatrixInt *)malloc(sizeof(MatrixInt));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = rows;
    res->cols = cols;
    // malloc res data
    res->data = (int *)malloc(sizeof(int) * rows * cols);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // init res->data with 0
    memset(res->data, 0, sizeof(int) * rows * cols);
    for (int i = 0; i < col; i++)
    {
        res->data[i * cols + i] = 1;
    }
    return res;
}

/***********************************************************
@description: generator zero matrix, every element type is int
@param {int} rows
@param {int} cols
@return {*}
 ************************************************************/
MatrixInt *zero_matrix_int(int rows, int cols)
{
    // check rows and cols
    if (rows <= 0 || cols <= 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // calc eye matrix diag len
    int col = (rows >= cols ? cols : rows);
    // malloc res
    MatrixInt *res = NULL;
    res = (MatrixInt *)malloc(sizeof(MatrixInt));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = rows;
    res->cols = cols;
    // malloc res data
    res->data = (int *)malloc(sizeof(int) * rows * cols);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // init res->data with 0
    memset(res->data, 0, sizeof(int) * rows * cols);
    return res;
}
