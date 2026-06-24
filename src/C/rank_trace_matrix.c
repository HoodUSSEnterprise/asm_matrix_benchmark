/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 20:28:22
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 14:47:33
@FilePath: \asm_matrix_benchmark\src\C\rank_trace_matrix.c
@Description: rank and trace of matrix
*************************************************************/
#include "rank_trace_matrix.h"
#include <math.h>

/***********************************************************
@description: rank of matrix
@param {MatrixInt} *m
@param {int} *rank
@return {*}
 ************************************************************/
bool rank_matrix_int(MatrixInt *m, int *rank)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check dimension
    if (m->rows == 0 || m->cols == 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // malloc new data
    double *data = (double *)malloc(sizeof(double) * m->rows * m->cols);
    if (data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return false;
    }
    for (size_t i = 0; i < m->rows * m->cols; i++)
    {
        data[i] = m->data[i] * 1.0;
    }

    // use gauss elimination
    for (size_t rows = 0, cols = 0; rows < m->rows && cols < m->cols; cols++)
    {
        // find main element
        size_t pivot = rows;
        while (fabs(data[pivot * m->cols + cols]) < 1e-6 && pivot < m->rows)
        {
            pivot++;
        }
        // that means this column is zero of all
        if (pivot == m->rows)
        {
            continue;
        }

        // exchange lines
        if (pivot != rows)
        {
            for (size_t j = 0; j < m->cols; j++)
            {
                double temp = data[pivot * m->cols + j];
                data[pivot * m->cols + j] = data[rows * m->cols + j];
                data[rows * m->cols + j] = temp;
            }
        }

        // elimination below line
        for (size_t i = rows + 1; i < m->rows; i++)
        {
            double factor = data[i * m->cols + cols] / data[rows * m->cols + cols];
            for (size_t j = cols; j < m->cols; j++)
            {
                data[i * m->cols + j] -= factor * data[rows * m->cols + j];
            }
        }
        rows++;
    }

    // calc non zero lines
    int rank_number = 0;
    // check line by line
    for (size_t i = 0; i < m->rows; i++)
    {
        bool flag = false;
        // check one by one
        for (size_t j = 0; j < m->cols; j++)
        {
            if (fabs(data[i * m->rows + j]) >= 1e-6)
            {
                flag = true;
                break;
            }
        }
        // check flag, if true means this line has non-zero number
        if (flag)
        {
            rank_number++;
        }
    }
    *rank = rank_number;
    free(data);
    return true;
}

/***********************************************************
@description: trace of matrix
@param {MatrixInt} *m
@param {int} *trace
@return {*}
 ************************************************************/
bool trace_matrix_int(MatrixInt *m, int *trace)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check dimension
    if (m->rows == 0 || m->cols == 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check is or not a square
    if (m->cols != m->rows)
    {
        fprintf(stderr, "It is not a square!\n");
        return false;
    }
    // calc trace
    int sum = 0;
    for (size_t i = 0; i < m->rows; i++)
    {
        sum += m->data[i * m->cols + i];
    }
    *trace = sum;
    return true;
}

/***********************************************************
@description: rank of matrix
@param {MatrixDouble} *m
@param {int} *rank
@return {*}
*************************************************************/
bool rank_matrix_double(MatrixDouble *m, int *rank)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check dimension
    if (m->rows == 0 || m->cols == 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // malloc new data
    double *data = (double *)malloc(sizeof(double) * m->rows * m->cols);
    if (data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return false;
    }
    for (size_t i = 0; i < m->rows * m->cols; i++)
    {
        data[i] = m->data[i];
    }

    // use gauss elimination
    for (size_t rows = 0, cols = 0; rows < m->rows && cols < m->cols; cols++)
    {
        // find main element
        size_t pivot = rows;
        while (fabs(data[pivot * m->cols + cols]) < 1e-6 && pivot < m->rows)
        {
            pivot++;
        }
        // that means this column is zero of all
        if (pivot == m->rows)
        {
            continue;
        }

        // exchange lines
        if (pivot != rows)
        {
            for (size_t j = 0; j < m->cols; j++)
            {
                double temp = data[pivot * m->cols + j];
                data[pivot * m->cols + j] = data[rows * m->cols + j];
                data[rows * m->cols + j] = temp;
            }
        }

        // elimination below line
        for (size_t i = rows + 1; i < m->rows; i++)
        {
            double factor = data[i * m->cols + cols] / data[rows * m->cols + cols];
            for (size_t j = cols; j < m->cols; j++)
            {
                data[i * m->cols + j] -= factor * data[rows * m->cols + j];
            }
        }
        rows++;
    }

    // calc non zero lines
    int rank_number = 0;
    // check line by line
    for (size_t i = 0; i < m->rows; i++)
    {
        bool flag = false;
        // check one by one
        for (size_t j = 0; j < m->cols; j++)
        {
            if (fabs(data[i * m->rows + j]) >= 1e-6)
            {
                flag = true;
                break;
            }
        }
        // check flag, if true means this line has non-zero number
        if (flag)
        {
            rank_number++;
        }
    }
    *rank = rank_number;
    free(data);
    return true;
}

/***********************************************************
@description: trace of matrix
@param {MatrixDouble} *m
@param {double} *trace
@return {*}
*************************************************************/
bool trace_matrix_double(MatrixDouble *m, double *trace)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check dimension
    if (m->rows == 0 || m->cols == 0)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check is or not a square
    if (m->cols != m->rows)
    {
        fprintf(stderr, "It is not a square!\n");
        return false;
    }
    // calc trace
    double sum = 0;
    for (size_t i = 0; i < m->rows; i++)
    {
        sum += m->data[i * m->cols + i];
    }
    *trace = sum;
    return true;
}