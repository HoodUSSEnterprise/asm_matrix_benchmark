/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-19 11:10:05
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-19 11:13:55
@FilePath: \asm_matrix_benchmark\src\C\compare_matrix.c
@Description: compare two matrix c code
*************************************************************/
#include "compare_matrix.h"

/***********************************************************
@description: compare two matrix both int type
@param {MatrixInt} *m1
@param {MatrixInt} *m2
@return {*}
 ************************************************************/
bool is_equal_matrix_int(MatrixInt *m1, MatrixInt *m2)
{
    // check m1 and m2
    if (m1 == NULL || m2 == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return false;
    }
    // check m1->data and m2->data
    if (m1->data == NULL || m2->data == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return NULL;
    }
    // check dimension
    if (m1->cols != m2->cols || m1->rows != m2->rows)
    {
        printf("Dimension mismatch! m1(%zu, %zu) vs m2(%zu, %zu)\n", m1->cols, m2->cols, m1->rows, m2->rows);
        return 0;
    }
    // check every elem
    for (size_t i = 0; i < m1->cols * m1->rows; i++)
    {
        if (m1->data[i] != m2->data[i])
        {
            return false;
        }
    }
    return true;
}