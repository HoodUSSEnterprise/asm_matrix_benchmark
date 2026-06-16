/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:15:53
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:19:24
@FilePath: \asm_matrix_benchmark\src\C\print_matrix.c
@Description: print matrix c code
*************************************************************/
#include "print_matrix.h"

/***********************************************************
@description: print matrix
@param {MatrixInt} *m
@return {*}
 ************************************************************/
void print_matrix(MatrixInt *m)
{
    if (m == NULL)
    {
        fprintf(stderr, "Invalid param!\n");
        return;
    }
    puts("------------------matrix info------------------");
    printf("matrix size: (%d, %d)\n", m->rows, m->cols);
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