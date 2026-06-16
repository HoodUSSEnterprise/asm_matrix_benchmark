/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-15 21:56:03
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 18:51:42
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
    // add matrix example
    puts("---------------------------------------add matrix---------------------------------------");
    MatrixInt *v = add_matrix_int(&v1, &v2);
    MatrixInt *m = add_matrix_int(&v1, &v3);
    print_matrix(v);
    print_matrix(m);
    puts("----------------------------------------------------------------------------------------");
    puts("---------------------------------------sub matrix---------------------------------------");
    v = sub_matrix_int(&v1, &v2);
    m = sub_matrix_int(&v1, &v3);
    print_matrix(v);
    print_matrix(m);
    puts("----------------------------------------------------------------------------------------");
    puts("---------------------------------------mul matrix---------------------------------------");
    int mul_data[3] = {1, 2, 3};
    MatrixInt mul1 = {mul_data, 3, 1};
    MatrixInt mul2 = {mul_data, 1, 3};
    m = mul_matrix_int(&mul1, &mul2);
    print_matrix(m);
    puts("----------------------------------------------------------------------------------------");
    puts("--------------------------------------scale matrix--------------------------------------");
    int scale_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixInt scale = {scale_data, 2, 5};
    print_matrix(&scale);
    m = scale_matrix_int(&scale, 2);
    print_matrix(m);
    return 0;
}