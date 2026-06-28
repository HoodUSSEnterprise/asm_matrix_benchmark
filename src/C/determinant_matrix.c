/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-28 08:42:24
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-28 12:30:26
@FilePath: \asm_matrix_benchmark\src\C\determinant_matrix.c
@Description: determinant of matrix c code

For integers, we temporarily store each data point as a fraction,
and we have implemented addition, subtraction, multiplication, and division operations for fractions.
Since all values involved are integers, there is no need to worry about precision issues.
However, it is important to note that if the data is too large, it may cause data overflow problems.
We recommend using high-precision calculations.

Note that when calculating the determinant of a matrix,
avoid using excessively small numbers,
such as 1e-20, as they may be easily treated as 0 by computers.
If you really need to calculate the determinant with such numbers,
it is strongly recommended to use symbolic computation.
*************************************************************/
#include "determinant_matrix.h"
#include "operator_fraction.h"

/***********************************************************
@description: determinant of MatrixInt
For integers, we temporarily store each data point as a fraction,
and we have implemented addition, subtraction, multiplication, and division operations for fractions.
Since all values involved are integers, there is no need to worry about precision issues.
However, it is important to note that if the data is too large, it may cause data overflow problems.
We recommend using high-precision calculations.
@param {MatrixInt} *m
@param {int} *det
@return {*}
*************************************************************/
bool determinant_int(MatrixInt *m, int *det)
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
    Fraction *data = (Fraction *)malloc(sizeof(Fraction) * m->rows * m->cols);
    if (data == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return false;
    }
    for (size_t i = 0; i < m->rows * m->cols; i++)
    {
        data[i].x = m->data[i];
        data[i].y = 1;
    }

    // use gauss elimination
    for (size_t rows = 0, cols = 0; rows < m->rows && cols < m->cols; cols++)
    {
        // find main element
        size_t pivot = rows;
        while (pivot < m->rows && fabs(data[pivot * m->cols + cols].x * 1.0 / data[pivot * m->cols + cols].y) < 1e-6)
        {
            pivot++;
        }
        // that means this column is zero of all
        /*
        Floating-point numbers have precision issues,
        and the way to determine whether they are zero is different from that of integers.
        Here, we temporarily treat them as 0 for viewing purposes, but not for calculation
        */
        if (pivot == m->rows)
        {
            *det = 0;
            return true;
        }

        // exchange lines
        if (pivot != rows)
        {
            for (size_t j = 0; j < m->cols; j++)
            {
                Fraction temp = data[pivot * m->cols + j];
                data[pivot * m->cols + j] = data[rows * m->cols + j];
                data[rows * m->cols + j] = temp;
            }
        }

        // elimination below line
        for (size_t i = rows + 1; i < m->rows; i++)
        {
            Fraction factor = div_fraction(&data[i * m->cols + cols], &data[rows * m->cols + cols]);
            for (size_t j = cols; j < m->cols; j++)
            {
                Fraction fraction = mul_fraction(&factor, &data[rows * m->cols + j]);
                data[i * m->cols + j] = sub_fraction(&data[i * m->cols + j], &fraction);
            }
        }
        rows++;
    }

    // The product of diagonal elements is the value of the determinant
    Fraction res = {1, 1};
    for (size_t i = 0; i < m->rows; i++)
    {
        res = mul_fraction(&res, &data[i * m->cols + i]);
    }
    free(data);
    *det = res.x;
    return true;
}

/***********************************************************
@description: determinant of MatrixFloat
Note that when calculating the determinant of a matrix,
avoid using excessively small numbers,
such as 1e-20, as they may be easily treated as 0 by computers.
If you really need to calculate the determinant with such numbers,
it is strongly recommended to use symbolic computation.
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
        if (pivot == m->rows)
        {
            *det = 0;
            return true;
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
Note that when calculating the determinant of a matrix,
avoid using excessively small numbers,
such as 1e-20, as they may be easily treated as 0 by computers.
If you really need to calculate the determinant with such numbers,
it is strongly recommended to use symbolic computation.
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
        if (pivot == m->rows)
        {
            *det = 0;
            return true;
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