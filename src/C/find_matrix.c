/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 10:35:02
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 14:38:44
@FilePath: \asm_matrix_benchmark\src\C\find_matrix.c
@Description: find elem position in matrix m
*************************************************************/
#include "find_matrix.h"

/***********************************************************
@description: find elem position in matrix m
@param {MatrixInt} *m
@param {int} elem
@param {Point} *pos
@return {*}
 ************************************************************/
bool find_elem_int(MatrixInt *m, int elem, Point *pos)
{
    // check m
    if (m == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check m->data
    if (m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    for (size_t i = 0; i < m->rows; i++)
    {
        for (size_t j = 0; j < m->cols; j++)
        {
            if (m->data[i * m->cols + j] == elem)
            {
                pos->x = i;
                pos->y = j;
                return true;
            }
        }
    }
    return false;
}

/***********************************************************
@description: find elem position in matrix m
@param {MatrixDouble} *m
@param {double} elem
@param {Point} *pos
@return {*}
*************************************************************/
bool find_elem_double(MatrixDouble *m, double elem, Point *pos)
{
    // check m
    if (m == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check m->data
    if (m->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    for (size_t i = 0; i < m->rows; i++)
    {
        for (size_t j = 0; j < m->cols; j++)
        {
            if (fabs(m->data[i * m->cols + j] - elem) < 1e-6)
            {
                pos->x = i;
                pos->y = j;
                return true;
            }
        }
    }
    return false;
}