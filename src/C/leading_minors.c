/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-21 15:45:55
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 14:54:07
@FilePath: \asm_matrix_benchmark\src\C\leading_minors.c
@Description: get leading principal minor c code
*************************************************************/
#include "leading_minors.h"

/***********************************************************
@description: get leading principal minor
@param {MatrixInt} *m
@return {*}
 ************************************************************/
Leading_Minors_Int *get_leading_minors_int(MatrixInt *m)
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
        return NULL;
    }
    if (m->cols != m->rows)
    {
        puts("It's not a square");
        return NULL;
    }
    // malloc new res
    Leading_Minors_Int *res = NULL;
    res = (Leading_Minors_Int *)malloc(sizeof(Leading_Minors_Int));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // get leading principal minor size
    res->len = m->rows;
    // malloc new res data
    res->matrix_data = (MatrixInt *)malloc(sizeof(MatrixInt) * m->rows);
    if (res->matrix_data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // malloc for every matrix and get data
    for (size_t order = 1; order <= m->rows; order++)
    {
        res->matrix_data[order - 1].rows = order;
        res->matrix_data[order - 1].cols = order;
        res->matrix_data[order - 1].data = (int *)malloc(sizeof(int) * order * order);
        if (res->matrix_data[order - 1].data == NULL)
        {
            // free malloc memory before
            for (size_t i = 0; i < order; i++)
            {
                free(res->matrix_data[i].data);
            }
            free(res->matrix_data);
            free(res);
            fprintf(stderr, "Memory allocation failed\n");
            return NULL;
        }
        for (size_t i = 0; i < order; i++)
        {
            for (size_t j = 0; j < order; j++)
            {
                res->matrix_data[order - 1].data[i * order + j] = m->data[i * m->cols + j];
            }
        }
    }
    return res;
}

/***********************************************************
@description: get leading principal minor
@param {MatrixInt} *m
@return {*}
*************************************************************/
Leading_Minors_Double *get_leading_minors_double(MatrixDouble *m)
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
        return NULL;
    }
    if (m->cols != m->rows)
    {
        puts("It's not a square");
        return NULL;
    }
    // malloc new res
    Leading_Minors_Double *res = NULL;
    res = (Leading_Minors_Double *)malloc(sizeof(Leading_Minors_Double));
    if (res == NULL)
    {
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // get leading principal minor size
    res->len = m->rows;
    // malloc new res data
    res->matrix_data = (MatrixDouble *)malloc(sizeof(MatrixDouble) * m->rows);
    if (res->matrix_data == NULL)
    {
        free(res);
        fprintf(stderr, "Memory allocation failed\n");
        return NULL;
    }
    // malloc for every matrix and get data
    for (size_t order = 1; order <= m->rows; order++)
    {
        res->matrix_data[order - 1].rows = order;
        res->matrix_data[order - 1].cols = order;
        res->matrix_data[order - 1].data = (double *)malloc(sizeof(double) * order * order);
        if (res->matrix_data[order - 1].data == NULL)
        {
            // free malloc memory before
            for (size_t i = 0; i < order; i++)
            {
                free(res->matrix_data[i].data);
            }
            free(res->matrix_data);
            free(res);
            fprintf(stderr, "Memory allocation failed\n");
            return NULL;
        }
        for (size_t i = 0; i < order; i++)
        {
            for (size_t j = 0; j < order; j++)
            {
                res->matrix_data[order - 1].data[i * order + j] = m->data[i * m->cols + j];
            }
        }
    }
    return res;
}