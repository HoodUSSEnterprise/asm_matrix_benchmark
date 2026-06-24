/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-21 20:22:13
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-21 20:34:06
@FilePath: \asm_matrix_benchmark\src\C\random_matrix.c
@Description: random matrix c code
*************************************************************/
#include "random_matrix.h"

/***********************************************************
@description: random matrix
@param {size_t} rows
@param {size_t} cols
@param {int} range must contains two number
@return {*}
 ************************************************************/
MatrixInt *random_matrix_int(size_t rows, size_t cols, int *range, size_t size)
{
    // check param
    if (rows <= 0 || cols <= 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check size
    int max_boundary = 0;
    int min_boundary = 0;
    // default parameter
    if (size == 0)
    {
        max_boundary = 10;
        min_boundary = 0;
    }
    else if (size == 1)
    {
        if (range[0] > 0)
        {
            max_boundary = range[0];
        }
        else if (range[0] == 0)
        {
            max_boundary = 10;
        }
        else
        {
            max_boundary = 0;
            min_boundary = range[0];
        }
    }
    else
    {
        if (range[0] >= range[1])
        {
            max_boundary = range[0];
            min_boundary = range[1];
        }
        else
        {
            max_boundary = range[1];
            min_boundary = range[0];
        }
    }
    // set the random number seed
    srand((unsigned)time(NULL));
    // malloc new res
    MatrixInt *res = NULL;
    res = (MatrixInt *)malloc(sizeof(MatrixInt));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = rows;
    res->cols = cols;
    // malloc new res data
    res->data = (int *)malloc(sizeof(int) * rows * cols);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    for (size_t i = 0; i < rows * cols; i++)
    {
        res->data[i] = rand() % (max_boundary - min_boundary + 1) + min_boundary;
    }
    return res;
}

/***********************************************************
@description: random matrix double
@param {size_t} rows
@param {size_t} cols
@param {double} range must contains two number
@return {*}
************************************************************/
MatrixDouble *random_matrix_double(size_t rows, size_t cols, double *range, size_t size)
{
    // check param
    if (rows <= 0 || cols <= 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check size
    double max_boundary = 10.0;
    double min_boundary = 0.0;
    // default parameter
    if (size == 0)
    {
        max_boundary = 10.0;
        min_boundary = 0.0;
    }
    else if (size == 1)
    {
        if (range[0] > 0)
        {
            max_boundary = range[0];
        }
        else if (range[0] == 0)
        {
            max_boundary = 10.0;
        }
        else
        {
            max_boundary = 0.0;
            min_boundary = range[0];
        }
    }
    else
    {
        if (range[0] >= range[1])
        {
            max_boundary = range[0];
            min_boundary = range[1];
        }
        else
        {
            max_boundary = range[1];
            min_boundary = range[0];
        }
    }
    // set the random number seed
    srand((unsigned)time(NULL));
    // malloc new res
    MatrixDouble *res = NULL;
    res = (MatrixDouble *)malloc(sizeof(MatrixDouble));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = rows;
    res->cols = cols;
    // malloc new res data
    res->data = (double *)malloc(sizeof(double) * rows * cols);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    for (size_t i = 0; i < rows * cols; i++)
    {
        double scale = (double)rand() / RAND_MAX;
        res->data[i] = min_boundary + scale * (max_boundary - min_boundary);
    }
    return res;
}