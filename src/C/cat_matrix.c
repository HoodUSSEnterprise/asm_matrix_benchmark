/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 20:59:10
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-17 09:09:23
@FilePath: \asm_matrix_benchmark\src\C\cat_matrix.c
@Description: cat matrix
*************************************************************/
#include "cat_matrix.h"

/***********************************************************
@description: cat matrix, axis : 1 means horizon, 0 means vertical
@param {MatrixInt} *m1
@param {MatrixInt} *m2
@param {int} axis : 1 means horizon, 0 means vertical
@return {*}
 ************************************************************/
MatrixInt *cat_matrix_int(MatrixInt *m1, MatrixInt *m2, int axis)
{
    // check m1 and m2
    if (m1 == NULL || m2 == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check m1->data and m2->data
    if (m1->data == NULL || m2->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // vertical, m1->cols must equal to m2->cols
    if (axis == 0)
    {
        // check dimension
        if (m1->cols != m2->cols)
        {
            printf("Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)\n", m1->rows, m1->cols, m2->rows, m2->cols);
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
        res->cols = m1->cols;
        res->rows = m1->rows + m2->rows;
        // malloc for res->data
        res->data = (int *)malloc(sizeof(int) * res->cols * res->rows);
        if (res->data == NULL)
        {
            free(res);
            fprintf(stderr, "Memory allocation failed\n");
            return NULL;
        }
        for (size_t i = 0; i < res->rows; i++)
        {
            for (size_t j = 0; j < res->cols; j++)
            {
                if (i < m1->rows)
                {
                    res->data[i * res->cols + j] = m1->data[i * res->cols + j];
                }
                else
                {
                    res->data[i * res->cols + j] = m2->data[(i - m1->rows) * res->cols + j];
                }
            }
        }
        return res;
    }
    // horizon, m1->rows must equal to m2->rows
    else if (axis == 1)
    {
        // check dimension
        if (m1->rows != m2->rows)
        {
            printf("Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)\n", m1->rows, m1->cols, m2->rows, m2->cols);
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
        res->rows = m1->rows;
        res->cols = m1->cols + m2->cols;
        // malloc for res->data
        res->data = (int *)malloc(sizeof(int) * res->cols * res->rows);
        if (res->data == NULL)
        {
            free(res);
            fprintf(stderr, "Memory allocation failed\n");
            return NULL;
        }
        for (size_t i = 0; i < res->rows; i++)
        {
            for (size_t j = 0; j < res->cols; j++)
            {
                if (j < m1->cols)
                {
                    res->data[i * res->cols + j] = m1->data[i * m1->cols + j];
                }
                else
                {
                    res->data[i * res->cols + j] = m2->data[i * m2->cols + j - m1->cols];
                }
            }
        }
        return res;
    }
    else
    {
        puts("Wrong value, axis must be 0 or 1");
        return NULL;
    }
}