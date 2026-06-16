/************************************************************
 *@Author: HoodUSSEnterprise
 *@Date: 2026-06-15 21:56:03
 *@FilePath: \asm_matrix\example\matrix_int.c
 *@Description: example of matrix int
 *************************************************************/

#include "add_matrix.h"

int main(void)
{
    int data[4] = {1, 2, 3, 4};
    MatrixInt v1 = {data, 2, 2};
    MatrixInt v2 = {data, 1, 4};
    MatrixInt *v = add_matrix_int(&v1, &v2);
    if (v == NULL)
    {
        puts("Wrong");
    }
    return 0;
}