/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-15 21:56:03
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 16:21:18
@FilePath: \asm_matrix_benchmark\example\matrix_int.c
@Description:example of matrix int
*************************************************************/

#include "matrix.h"

int main(void)
{
    int data[4] = {1, 2, 3, 4};
    MatrixInt v1 = {data, 2, 2};
    MatrixInt v2 = {data, 1, 4};
    MatrixInt v3 = {data, 2, 2};
    MatrixInt *v = add_matrix_int(&v1, &v2);
    MatrixInt *m = add_matrix_int(&v1, &v3);
    print_matrix(v);
    print_matrix(m);
    return 0;
}