/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-28 08:42:24
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-28 09:10:21
@FilePath: \asm_matrix_benchmark\src\C\determinant_matrix.c
@Description: determinant of matrix c code
*************************************************************/
#include "determinant_matrix.h"

/***********************************************************
@description: determinant of MatrixInt
@param {MatrixInt} *m
@param {int} *det
@return {*}
*************************************************************/
bool determinant_int(MatrixInt *m, int *det);

/***********************************************************
@description: determinant of MatrixFloat
@param {MatrixFloat} *m
@param {double} *det
@return {*}
*************************************************************/
bool determinant_float(MatrixFloat *m, double *det)
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
        while (pivot < m->rows && fabs(data[pivot * m->cols + cols]) < 1e-6)
        {
            pivot++;
        }
        // that means this column is zero of all
        /*
        Floating-point numbers have precision issues,
        and the way to determine whether they are zero is different from that of integers.
        Here, we temporarily treat them as 0 for viewing purposes, but not for calculation
        */
        // TODO
        /*
        There are some issues here, such as extremely small numbers like 1e-20,
        which are treated as 0 in computers but are actually not zero.
        We will use the condition number to address this later.
        */
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

    // The product of diagonal elements is the value of the determinant
    double res = 1.0;
    for (size_t i = 0; i < m->rows; i++)
    {
        res *= data[i * m->cols + i];
    }
    free(data);
    *det = res;
    return true;
}

/***********************************************************
@description: determinant of MatrixDouble
@param {MatrixDouble} *m
@param {double} *det
@return {*}
*************************************************************/
bool determinant_double(MatrixDouble *m, double *det)
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
        while (pivot < m->rows && fabs(data[pivot * m->cols + cols]) < 1e-6)
        {
            pivot++;
        }
        // that means this column is zero of all
        /*
        Floating-point numbers have precision issues,
        and the way to determine whether they are zero is different from that of integers.
        Here, we temporarily treat them as 0 for viewing purposes, but not for calculation
        */
        // TODO
        /*
        There are some issues here, such as extremely small numbers like 1e-20,
        which are treated as 0 in computers but are actually not zero.
        We will use the condition number to address this later.
        */
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

    // The product of diagonal elements is the value of the determinant
    double res = 1.0;
    for (size_t i = 0; i < m->rows; i++)
    {
        res *= data[i * m->cols + i];
    }
    free(data);
    *det = res;
    return true;
}