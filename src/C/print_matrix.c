/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:15:53
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-21 12:56:51
@FilePath: \asm_matrix_benchmark\src\C\print_matrix.c
@Description: print matrix c code
*************************************************************/
#include "print_matrix.h"

/***********************************************************
@description: print matrix int
@param {MatrixInt} *m
@return {*}
 ************************************************************/
void print_matrix_int(MatrixInt *m)
{
    if (m == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    puts("------------------matrix info------------------");
    printf("matrix size: (%zu, %zu)\n", m->rows, m->cols);
    puts("matrix data:");
    for (size_t i = 0; i < m->rows; i++)
    {
        for (size_t j = 0; j < m->cols; j++)
        {
            printf("%d ", m->data[i * m->cols + j]);
        }
        putchar('\n');
    }
}

/***********************************************************
@description: print matrix double
@param {MatrixDouble} *m
@return {*}
 ************************************************************/
void print_matrix_double(MatrixDouble *m)
{
    if (m == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    puts("------------------matrix info------------------");
    printf("matrix size: (%zu, %zu)\n", m->rows, m->cols);
    puts("matrix data:");
    for (size_t i = 0; i < m->rows; i++)
    {
        for (size_t j = 0; j < m->cols; j++)
        {
            printf("%lf ", m->data[i * m->cols + j]);
        }
        putchar('\n');
    }
}

/***********************************************************
@description: print matrix float
@param {MatrixFloat} *m
@return {*}
************************************************************/
void print_matrix_float(MatrixFloat *m)
{
    if (m == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    puts("------------------matrix info------------------");
    printf("matrix size: (%zu, %zu)\n", m->rows, m->cols);
    puts("matrix data:");
    for (size_t i = 0; i < m->rows; i++)
    {
        for (size_t j = 0; j < m->cols; j++)
        {
            printf("%f ", m->data[i * m->cols + j]);
        }
        putchar('\n');
    }
}