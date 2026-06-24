/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-20 14:37:33
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 16:13:26
@FilePath: \asm_matrix_benchmark\src\C\inv_matrix.c
@Description: invertible matrix c code
*************************************************************/

#include "inv_matrix.h"
#include "rank_trace_matrix.h"
#include <math.h>

/***********************************************************
@description: inv matrix int
@param {MatrixInt*} m
@return {*}
 ************************************************************/
MatrixDouble *inv_matrix_int(MatrixInt *m)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check dimension
    if (m->cols != m->rows)
    {
        puts("It's not a square");
        return NULL;
    }
    // check the matrix is invertible or not
    int rank = 0;
    if (rank_matrix_int(m, &rank) == false)
    {
        return NULL;
    }
    else
    {
        if ((size_t)rank != m->cols)
        {
            fprintf(stderr, "It not invertible matrix\n");
            return NULL;
        }
    }
    // malloc for new res
    MatrixDouble *res = NULL;
    res = (MatrixDouble *)malloc(sizeof(MatrixDouble));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = m->rows;
    res->cols = m->cols;
    // malloc for new res data
    res->data = (double *)malloc(sizeof(double) * res->rows * res->cols);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // malloc new augmented matrix
    MatrixDouble *aug_matrix = NULL;
    aug_matrix = (MatrixDouble *)malloc(sizeof(MatrixDouble));
    if (aug_matrix == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    aug_matrix->rows = m->rows;
    aug_matrix->cols = m->cols * 2;
    // malloc for new aug_matrix data
    aug_matrix->data = (double *)malloc(sizeof(double) * aug_matrix->rows * aug_matrix->cols);
    if (aug_matrix->data == NULL)
    {
        free(aug_matrix);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // init aug_matrix
    for (size_t i = 0; i < aug_matrix->rows; i++)
    {
        for (size_t j = 0; j < aug_matrix->cols; j++)
        {
            if (j < m->cols)
            {
                aug_matrix->data[i * aug_matrix->cols + j] = m->data[i * m->cols + j] * 1.0;
            }
            else
            {
                if (j - i == m->rows)
                {
                    aug_matrix->data[i * aug_matrix->cols + j] = 1;
                }
                else
                {
                    aug_matrix->data[i * aug_matrix->cols + j] = 0;
                }
            }
        }
    }
    // use gauss elimination
    for (size_t rows = 0, cols = 0; rows < aug_matrix->rows; cols++)
    {
        // find main element
        size_t pivot = rows;
        while (fabs(aug_matrix->data[pivot * aug_matrix->cols + cols]) < 1e-6 && pivot < aug_matrix->rows)
        {
            pivot++;
        }
        // that means this column is zero of all
        if (pivot == aug_matrix->rows)
        {
            continue;
        }

        // exchange lines
        if (pivot != rows)
        {
            for (size_t j = 0; j < aug_matrix->cols; j++)
            {
                double temp = aug_matrix->data[pivot * aug_matrix->cols + j];
                aug_matrix->data[pivot * aug_matrix->cols + j] = aug_matrix->data[rows * aug_matrix->cols + j];
                aug_matrix->data[rows * aug_matrix->cols + j] = temp;
            }
        }

        // normalization
        double pivot_val = aug_matrix->data[rows * aug_matrix->cols + cols];
        for (size_t j = cols; j < aug_matrix->cols; j++)
        {
            aug_matrix->data[rows * aug_matrix->cols + j] /= pivot_val;
        }

        // elimination this line
        for (size_t i = 0; i < aug_matrix->rows; i++)
        {
            if (i == rows)
            {
                continue;
            }
            double factor = aug_matrix->data[i * aug_matrix->cols + cols] / aug_matrix->data[rows * aug_matrix->cols + cols];
            for (size_t j = cols; j < aug_matrix->cols; j++)
            {
                aug_matrix->data[i * aug_matrix->cols + j] -= factor * aug_matrix->data[rows * aug_matrix->cols + j];
            }
        }
        rows++;
    }
    // extract res
    for (size_t i = 0; i < res->rows; i++)
    {
        for (size_t j = 0; j < res->cols; j++)
        {
            res->data[i * res->cols + j] = aug_matrix->data[i * aug_matrix->cols + m->cols + j];
        }
    }
    // free aug_matrix
    free(aug_matrix->data);
    free(aug_matrix);
    return res;
}

/***********************************************************
@description: inv matrix float
@param {MatrixFloat} *m
@return {*}
************************************************************/
MatrixFloat *inv_matrix_float(MatrixFloat *m)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check dimension
    if (m->cols != m->rows)
    {
        puts("It's not a square");
        return NULL;
    }
    // check the matrix is invertible or not
    int rank = 0;
    if (rank_matrix_float(m, &rank) == false)
    {
        return NULL;
    }
    else
    {
        if ((size_t)rank != m->cols)
        {
            fprintf(stderr, "It not invertible matrix\n");
            return NULL;
        }
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
    res->cols = m->cols;
    // malloc for new res data
    res->data = (float *)malloc(sizeof(float) * res->rows * res->cols);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // malloc new augmented matrix
    MatrixFloat *aug_matrix = NULL;
    aug_matrix = (MatrixFloat *)malloc(sizeof(MatrixFloat));
    if (aug_matrix == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    aug_matrix->rows = m->rows;
    aug_matrix->cols = m->cols * 2;
    // malloc for new aug_matrix data
    aug_matrix->data = (float *)malloc(sizeof(float) * aug_matrix->rows * aug_matrix->cols);
    if (aug_matrix->data == NULL)
    {
        free(aug_matrix);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // init aug_matrix
    for (size_t i = 0; i < aug_matrix->rows; i++)
    {
        for (size_t j = 0; j < aug_matrix->cols; j++)
        {
            if (j < m->cols)
            {
                aug_matrix->data[i * aug_matrix->cols + j] = m->data[i * m->cols + j];
            }
            else
            {
                if (j - i == m->rows)
                {
                    aug_matrix->data[i * aug_matrix->cols + j] = 1.0f;
                }
                else
                {
                    aug_matrix->data[i * aug_matrix->cols + j] = 0.0f;
                }
            }
        }
    }
    // use gauss elimination
    for (size_t rows = 0, cols = 0; rows < aug_matrix->rows; cols++)
    {
        // find main element
        size_t pivot = rows;
        while (fabsf(aug_matrix->data[pivot * aug_matrix->cols + cols]) < 1e-5f && pivot < aug_matrix->rows)
        {
            pivot++;
        }
        // that means this column is zero of all
        if (pivot == aug_matrix->rows)
        {
            continue;
        }

        // exchange lines
        if (pivot != rows)
        {
            for (size_t j = 0; j < aug_matrix->cols; j++)
            {
                float temp = aug_matrix->data[pivot * aug_matrix->cols + j];
                aug_matrix->data[pivot * aug_matrix->cols + j] = aug_matrix->data[rows * aug_matrix->cols + j];
                aug_matrix->data[rows * aug_matrix->cols + j] = temp;
            }
        }

        // normalization
        float pivot_val = aug_matrix->data[rows * aug_matrix->cols + cols];
        for (size_t j = cols; j < aug_matrix->cols; j++)
        {
            aug_matrix->data[rows * aug_matrix->cols + j] /= pivot_val;
        }

        // elimination this line
        for (size_t i = 0; i < aug_matrix->rows; i++)
        {
            if (i == rows)
            {
                continue;
            }
            float factor = aug_matrix->data[i * aug_matrix->cols + cols] / aug_matrix->data[rows * aug_matrix->cols + cols];
            for (size_t j = cols; j < aug_matrix->cols; j++)
            {
                aug_matrix->data[i * aug_matrix->cols + j] -= factor * aug_matrix->data[rows * aug_matrix->cols + j];
            }
        }
        rows++;
    }
    // extract res
    for (size_t i = 0; i < res->rows; i++)
    {
        for (size_t j = 0; j < res->cols; j++)
        {
            res->data[i * res->cols + j] = aug_matrix->data[i * aug_matrix->cols + m->cols + j];
        }
    }
    // free aug_matrix
    free(aug_matrix->data);
    free(aug_matrix);
    return res;
}

/***********************************************************
@description: inv matrix double
@param {MatrixDouble} *m
@return {*}
************************************************************/
MatrixDouble *inv_matrix_double(MatrixDouble *m)
{
    // check m and m->data
    if (m == NULL || m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check dimension
    if (m->cols != m->rows)
    {
        puts("It's not a square");
        return NULL;
    }
    // check the matrix is invertible or not
    int rank = 0;
    if (rank_matrix_double(m, &rank) == false)
    {
        return NULL;
    }
    else
    {
        if ((size_t)rank != m->cols)
        {
            fprintf(stderr, "It not invertible matrix\n");
            return NULL;
        }
    }
    // malloc for new res
    MatrixDouble *res = NULL;
    res = (MatrixDouble *)malloc(sizeof(MatrixDouble));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    res->rows = m->rows;
    res->cols = m->cols;
    // malloc for new res data
    res->data = (double *)malloc(sizeof(double) * res->rows * res->cols);
    if (res->data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // malloc new augmented matrix
    MatrixDouble *aug_matrix = NULL;
    aug_matrix = (MatrixDouble *)malloc(sizeof(MatrixDouble));
    if (aug_matrix == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    aug_matrix->rows = m->rows;
    aug_matrix->cols = m->cols * 2;
    // malloc for new aug_matrix data
    aug_matrix->data = (double *)malloc(sizeof(double) * aug_matrix->rows * aug_matrix->cols);
    if (aug_matrix->data == NULL)
    {
        free(aug_matrix);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // init aug_matrix
    for (size_t i = 0; i < aug_matrix->rows; i++)
    {
        for (size_t j = 0; j < aug_matrix->cols; j++)
        {
            if (j < m->cols)
            {
                aug_matrix->data[i * aug_matrix->cols + j] = m->data[i * m->cols + j];
            }
            else
            {
                if (j - i == m->rows)
                {
                    aug_matrix->data[i * aug_matrix->cols + j] = 1.0;
                }
                else
                {
                    aug_matrix->data[i * aug_matrix->cols + j] = 0.0;
                }
            }
        }
    }
    // use gauss elimination
    for (size_t rows = 0, cols = 0; rows < aug_matrix->rows; cols++)
    {
        // find main element
        size_t pivot = rows;
        while (fabs(aug_matrix->data[pivot * aug_matrix->cols + cols]) < 1e-6 && pivot < aug_matrix->rows)
        {
            pivot++;
        }
        // that means this column is zero of all
        if (pivot == aug_matrix->rows)
        {
            continue;
        }

        // exchange lines
        if (pivot != rows)
        {
            for (size_t j = 0; j < aug_matrix->cols; j++)
            {
                double temp = aug_matrix->data[pivot * aug_matrix->cols + j];
                aug_matrix->data[pivot * aug_matrix->cols + j] = aug_matrix->data[rows * aug_matrix->cols + j];
                aug_matrix->data[rows * aug_matrix->cols + j] = temp;
            }
        }

        // normalization
        double pivot_val = aug_matrix->data[rows * aug_matrix->cols + cols];
        for (size_t j = cols; j < aug_matrix->cols; j++)
        {
            aug_matrix->data[rows * aug_matrix->cols + j] /= pivot_val;
        }

        // elimination this line
        for (size_t i = 0; i < aug_matrix->rows; i++)
        {
            if (i == rows)
            {
                continue;
            }
            double factor = aug_matrix->data[i * aug_matrix->cols + cols] / aug_matrix->data[rows * aug_matrix->cols + cols];
            for (size_t j = cols; j < aug_matrix->cols; j++)
            {
                aug_matrix->data[i * aug_matrix->cols + j] -= factor * aug_matrix->data[rows * aug_matrix->cols + j];
            }
        }
        rows++;
    }
    // extract res
    for (size_t i = 0; i < res->rows; i++)
    {
        for (size_t j = 0; j < res->cols; j++)
        {
            res->data[i * res->cols + j] = aug_matrix->data[i * aug_matrix->cols + m->cols + j];
        }
    }
    // free aug_matrix
    free(aug_matrix->data);
    free(aug_matrix);
    return res;
}
