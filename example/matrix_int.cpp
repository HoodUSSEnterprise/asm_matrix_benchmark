/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:46:42
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:47:32
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
    MatrixInt m = v1 + v3;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------sub matrix---------------------------------------");
    m = v1 - v3;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------mul matrix---------------------------------------");
    int mul_data[3] = {1, 2, 3};
    MatrixInt mul1(mul_data, 3, 1);
    MatrixInt mul2(mul_data, 1, 3);
    m = mul1 * mul2;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("--------------------------------------scale matrix--------------------------------------");
    int scale_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixInt scale(scale_data, 2, 5);
    std::cout << scale;
    m = scale * 2;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------cat matrix---------------------------------------");
    int cat_data1[3] = {1, 2, 3};
    int cat_data2[6] = {4, 5, 6, 7, 8, 9};
    MatrixInt cat1(cat_data1, 1, 3);
    MatrixInt cat2(cat_data2, 2, 3);
    m = cat1.cat(cat2, 0);
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("--------------------------------------find matrix---------------------------------------");
    int find_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixInt find_m(find_data, 5, 2);
    std::cout << find_m;
    auto p = find_m.find_elem(5);
    if (p.first != -1)
    {
        printf("find elem 5 at (%d, %d)\n", p.first, p.second);
    }
    else
    {
        printf("No find elem 5\n");
    }
    p = find_m.find_elem(11);
    if (p.first != -1)
    {
        printf("find elem 11 at (%d, %d)\n", p.first, p.second);
    }
    else
    {
        printf("No find elem 11\n");
    }
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------replace matrix-------------------------------------");
    int replace_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixInt replace_m(replace_data, 5, 2);
    replace_m.replace_pos(0, 0, 99);
    std::cout << replace_m;
    replace_m.replace_elem(7, 77);
    std::cout << replace_m;
    puts("----------------------------------------------------------------------------------------");

    puts("------------------------------------transpose matrix------------------------------------");
    int transpose_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixInt raw(transpose_data, 5, 2);
    std::cout << raw;
    MatrixInt t = raw.transpose();
    std::cout << t;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------special matrix-------------------------------------");
    MatrixInt I = MatrixInt::identity(4);
    std::cout << I;
    MatrixInt Z = MatrixInt::zeros(3, 4);
    std::cout << Z;
    MatrixInt O = MatrixInt::ones(2, 3);
    std::cout << O;
    MatrixInt R = MatrixInt::random(3, 3, 0, 10);
    std::cout << R;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------rank and trace-------------------------------------");
    int rt_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    MatrixInt rt_m(rt_data, 3, 3);
    std::cout << rt_m;
    printf("matrix rank = %zu\n", rt_m.rank());
    printf("matrix trace = %d\n", rt_m.trace());
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------compare matrix-------------------------------------");
    int comp1_data[6] = {1, 2, 3, 4, 5, 6};
    int comp2_data[6] = {6, 5, 4, 3, 2, 1};
    MatrixInt cmp1(comp1_data, 2, 3);
    MatrixInt cmp2(comp1_data, 2, 3);
    MatrixInt cmp3(comp2_data, 2, 3);
    std::cout << (cmp1 == cmp2 ? "Two matrix equals\n" : "Two matrix not equals\n");
    std::cout << (cmp1 == cmp3 ? "Two matrix equals\n" : "Two matrix not equals\n");
    std::cout << (cmp1 != cmp3 ? "Two matrix not equals\n" : "Two matrix equals\n");
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------determinant and leading minors---------------------");
    int lead_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 10};
    MatrixInt lead_m(lead_data, 3, 3);
    std::cout << lead_m;
    auto minors = lead_m.leading_minors();
    printf("leading minors count = %zu\n", minors.size());
    for (size_t i = 0; i < minors.size(); i++)
    {
        printf("--- order %zu ---\n", i + 1);
        std::cout << minors[i];
    }
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------extract submatrix----------------------------------");
    int ext_data[12] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
    MatrixInt ext_m(ext_data, 3, 4);
    std::cout << ext_m;
    MatrixInt row = ext_m.extract_row(1);
    std::cout << row;
    MatrixInt col = ext_m.extract_col(2);
    std::cout << col;
    MatrixInt block = ext_m.extract_submatrix(0, 2, 1, 3);
    std::cout << block;
    puts("----------------------------------------------------------------------------------------");

    return 0;
}
