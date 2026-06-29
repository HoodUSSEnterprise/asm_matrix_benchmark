/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 10:32:52
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-29 13:54:37
@FilePath: \asm_matrix_benchmark\example\matrix_float.cpp
@Description: example of matrix float
*************************************************************/

#include "matrix_float_cpp.h"
#include <cstdio>

int main()
{
    float data[4] = {1, 2, 3, 4};
    MatrixFloat v1(data, 2, 2);
    MatrixFloat v2(data, 1, 4);
    MatrixFloat v3(data, 2, 2);

    // add matrix example
    puts("---------------------------------------add matrix---------------------------------------");
    MatrixFloat m = v1 + v3;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------sub matrix---------------------------------------");
    m = v1 - v3;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------mul matrix---------------------------------------");
    float mul_data[3] = {1, 2, 3};
    MatrixFloat mul1(mul_data, 3, 1);
    MatrixFloat mul2(mul_data, 1, 3);
    m = mul1 * mul2;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("--------------------------------------scale matrix--------------------------------------");
    float scale_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixFloat scale(scale_data, 2, 5);
    std::cout << scale;
    m = scale * 2;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------cat matrix---------------------------------------");
    float cat_data1[3] = {1, 2, 3};
    float cat_data2[6] = {4, 5, 6, 7, 8, 9};
    MatrixFloat cat1(cat_data1, 1, 3);
    MatrixFloat cat2(cat_data2, 2, 3);
    m = cat1.cat(cat2, 0);
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("--------------------------------------find matrix---------------------------------------");
    float find_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixFloat find_m(find_data, 5, 2);
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
    float replace_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixFloat replace_m(replace_data, 5, 2);
    replace_m.replace_pos(0, 0, 99);
    std::cout << replace_m;
    replace_m.replace_elem(7, 77);
    std::cout << replace_m;
    puts("----------------------------------------------------------------------------------------");

    puts("------------------------------------transpose matrix------------------------------------");
    float transpose_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixFloat raw(transpose_data, 5, 2);
    std::cout << raw;
    MatrixFloat t = raw.transpose();
    std::cout << t;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------special matrix-------------------------------------");
    MatrixFloat I = MatrixFloat::identity(4);
    std::cout << I;
    MatrixFloat Z = MatrixFloat::zeros(3, 4);
    std::cout << Z;
    MatrixFloat O = MatrixFloat::ones(2, 3);
    std::cout << O;
    MatrixFloat R = MatrixFloat::random(3, 3, 0, 10);
    std::cout << R;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------rank and trace-------------------------------------");
    float rt_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    MatrixFloat rt_m(rt_data, 3, 3);
    std::cout << rt_m;
    printf("matrix rank = %zu\n", rt_m.rank());
    std::cout << "matrix trace = " << rt_m.trace() << std::endl;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------compare matrix-------------------------------------");
    float comp1_data[6] = {1, 2, 3, 4, 5, 6};
    float comp2_data[6] = {6, 5, 4, 3, 2, 1};
    MatrixFloat cmp1(comp1_data, 2, 3);
    MatrixFloat cmp2(comp1_data, 2, 3);
    MatrixFloat cmp3(comp2_data, 2, 3);
    std::cout << (cmp1 == cmp2 ? "Two matrix equals\n" : "Two matrix not equals\n");
    std::cout << (cmp1 == cmp3 ? "Two matrix equals\n" : "Two matrix not equals\n");
    std::cout << (cmp1 != cmp3 ? "Two matrix not equals\n" : "Two matrix equals\n");
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------invertible matrix-------------------------------------");
    float inv_matrix[9] = {1, 2, 3, 0, 4, 5, 1, 0, 6};
    MatrixFloat matrix_orgin(inv_matrix, 3, 3);
    MatrixDouble matrix_inv(3, 3);
    matrix_inv = matrix_orgin.inv_matrix();
    std::cout << matrix_inv;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------leading minors-------------------------------------");
    float lead_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 10};
    MatrixFloat lead_m(lead_data, 3, 3);
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
    float ext_data[12] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
    MatrixFloat ext_m(ext_data, 3, 4);
    std::cout << ext_m;
    MatrixFloat row = ext_m.extract_row(1);
    std::cout << row;
    MatrixFloat col = ext_m.extract_col(2);
    std::cout << col;
    MatrixFloat block = ext_m.extract_submatrix(0, 2, 1, 3);
    std::cout << block;
    puts("----------------------------------------------------------------------------------------");

    return 0;
}
