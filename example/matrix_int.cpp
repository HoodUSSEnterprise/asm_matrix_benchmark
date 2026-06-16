/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:46:42
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:53:30
@FilePath: \asm_matrix_benchmark\example\matrix_int.cpp
@Description:example of matrix int c++
*************************************************************/

#include "matrix_cpp.h"
#include <cstdio>

int main()
{
    int data[4] = {1, 2, 3, 4};
    MatrixInt v1(data, 2, 2);
    MatrixInt v2(data, 1, 4);
    MatrixInt v3(data, 2, 2);

    // add matrix example
    puts("---------------------------------------add matrix---------------------------------------");
    MatrixInt m = v1.add_matrix(v1, v3);
    m.print_matrix();
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------sub matrix---------------------------------------");
    m = v1.sub_matrix(v1, v3);
    m.print_matrix();
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------mul matrix---------------------------------------");
    int mul_data[3] = {1, 2, 3};
    MatrixInt mul1(mul_data, 3, 1);
    MatrixInt mul2(mul_data, 1, 3);
    m = mul1.mul_matrix(mul1, mul2);
    m.print_matrix();
    puts("----------------------------------------------------------------------------------------");

    puts("--------------------------------------scale matrix--------------------------------------");
    int scale_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixInt scale(scale_data, 2, 5);
    scale.print_matrix();
    m = scale.scale_matrix(scale, 2);
    m.print_matrix();

    return 0;
}
