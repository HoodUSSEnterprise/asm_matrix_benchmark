/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 10:32:52
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-29 10:36:11
@FilePath: \asm_matrix_benchmark\example\matrix_double.cpp
@Description: example of matrix double c++
*************************************************************/

#include "matrix_double_cpp.h"
#include <cstdio>

int main()
{
    double data[4] = {1, 2, 3, 4};
    MatrixDouble v1(data, 2, 2);
    MatrixDouble v2(data, 1, 4);
    MatrixDouble v3(data, 2, 2);

    // add matrix example
    puts("---------------------------------------add matrix---------------------------------------");
    MatrixDouble m = v1 + v3;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------sub matrix---------------------------------------");
    m = v1 - v3;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------mul matrix---------------------------------------");
    double mul_data[3] = {1, 2, 3};
    MatrixDouble mul1(mul_data, 3, 1);
    MatrixDouble mul2(mul_data, 1, 3);
    m = mul1 * mul2;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("--------------------------------------scale matrix--------------------------------------");
    double scale_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixDouble scale(scale_data, 2, 5);
    std::cout << scale;
    m = scale * 2;
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("---------------------------------------cat matrix---------------------------------------");
    double cat_data1[3] = {1, 2, 3};
    double cat_data2[6] = {4, 5, 6, 7, 8, 9};
    MatrixDouble cat1(cat_data1, 1, 3);
    MatrixDouble cat2(cat_data2, 2, 3);
    m = cat1.cat(cat2, 0);
    std::cout << m;
    puts("----------------------------------------------------------------------------------------");

    puts("--------------------------------------find matrix---------------------------------------");
    double find_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixDouble find_m(find_data, 5, 2);
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
    double replace_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixDouble replace_m(replace_data, 5, 2);
    replace_m.replace_pos(0, 0, 99);
    std::cout << replace_m;
    replace_m.replace_elem(7, 77);
    std::cout << replace_m;
    puts("----------------------------------------------------------------------------------------");

    puts("------------------------------------transpose matrix------------------------------------");
    double transpose_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixDouble raw(transpose_data, 5, 2);
    std::cout << raw;
    MatrixDouble t = raw.transpose();
    std::cout << t;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------special matrix-------------------------------------");
    MatrixDouble I = MatrixDouble::identity(4);
    std::cout << I;
    MatrixDouble Z = MatrixDouble::zeros(3, 4);
    std::cout << Z;
    MatrixDouble O = MatrixDouble::ones(2, 3);
    std::cout << O;
    MatrixDouble R = MatrixDouble::random(3, 3, 0, 10);
    std::cout << R;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------rank and trace-------------------------------------");
    double rt_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    MatrixDouble rt_m(rt_data, 3, 3);
    std::cout << rt_m;
    printf("matrix rank = %zu\n", rt_m.rank());
    std::cout << "matrix trace = " << rt_m.trace() << std::endl;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------compare matrix-------------------------------------");
    double comp1_data[6] = {1, 2, 3, 4, 5, 6};
    double comp2_data[6] = {6, 5, 4, 3, 2, 1};
    MatrixDouble cmp1(comp1_data, 2, 3);
    MatrixDouble cmp2(comp1_data, 2, 3);
    MatrixDouble cmp3(comp2_data, 2, 3);
    std::cout << (cmp1 == cmp2 ? "Two matrix equals\n" : "Two matrix not equals\n");
    std::cout << (cmp1 == cmp3 ? "Two matrix equals\n" : "Two matrix not equals\n");
    std::cout << (cmp1 != cmp3 ? "Two matrix not equals\n" : "Two matrix equals\n");
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------invertible matrix-------------------------------------");
    double inv_matrix[9] = {1, 2, 3, 0, 4, 5, 1, 0, 6};
    MatrixDouble matrix_orgin(inv_matrix, 3, 3);
    MatrixDouble matrix_inv = matrix_orgin.inv_matrix();
    std::cout << matrix_inv;
    puts("----------------------------------------------------------------------------------------");

    puts("-------------------------------------leading minors-------------------------------------");
    double lead_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 10};
    MatrixDouble lead_m(lead_data, 3, 3);
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
    double ext_data[12] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
    MatrixDouble ext_m(ext_data, 3, 4);
    std::cout << ext_m;
    MatrixDouble row = ext_m.extract_row(1);
    std::cout << row;
    MatrixDouble col = ext_m.extract_col(2);
    std::cout << col;
    MatrixDouble block = ext_m.extract_submatrix(0, 2, 1, 3);
    std::cout << block;
    puts("----------------------------------------------------------------------------------------");

    return 0;
}
