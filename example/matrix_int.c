/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-15 21:56:03
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-17 16:53:18
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
    puts("----------------------------------------------------------------------------------------");
    puts("---------------------------------------cat matrix---------------------------------------");
    int cat_data1[3] = {1, 2, 3};
    int cat_data2[6] = {4, 5, 6, 7, 8, 9};
    MatrixInt cat_matrix1 = {cat_data1, 1, 3};
    MatrixInt cat_matrix2 = {cat_data2, 2, 3};
    m = cat_matrix_int(&cat_matrix1, &cat_matrix2, 0);
    print_matrix(m);
    MatrixInt cat_matrix3 = {cat_data1, 3, 1};
    MatrixInt cat_matrix4 = {cat_data2, 3, 2};
    m = cat_matrix_int(&cat_matrix3, &cat_matrix4, 1);
    print_matrix(m);
    puts("----------------------------------------------------------------------------------------");
    puts("--------------------------------------find matrix---------------------------------------");
    int find_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixInt find_matrix = {find_data, 5, 2};
    print_matrix(&find_matrix);
    Point p = {0, 0};
    int find_elem = 5;
    if (find_elem_int(&find_matrix, find_elem, &p))
    {
        puts("find elem");
        printf("Position is (%zu, %zu)\n", p.x, p.y);
    }
    else
    {
        printf("No find elem : %d\n", find_elem);
    }
    find_elem = 11;
    if (find_elem_int(&find_matrix, find_elem, &p))
    {
        puts("find elem");
        printf("Position is (%zu, %zu)\n", p.x, p.y);
    }
    else
    {
        printf("No find elem : %d\n", find_elem);
    }
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------replace matrix-------------------------------------");
    int replace_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixInt replace_matrix = {replace_data, 5, 2};
    Point replace_pos = {10, 2};
    if (replace_matrix_int_by_coord(&replace_matrix, &replace_pos, 10))
    {
        print_matrix(&replace_matrix);
    }
    else
    {
        printf("(%zu, %zu) has out of index range\n", replace_pos.x, replace_pos.y);
    }
    replace_pos = (Point){0, 0};
    if (replace_matrix_int_by_coord(&replace_matrix, &replace_pos, 10))
    {
        print_matrix(&replace_matrix);
    }
    else
    {
        printf("(%zu, %zu) has out of index range\n", replace_pos.x, replace_pos.y);
    }
    int old_data = 7;
    int new_data = 10;
    if (replace_matrix_int_by_value(&replace_matrix, old_data, new_data))
    {
        print_matrix(&replace_matrix);
    }
    else
    {
        printf("%d has not in matrix\n", old_data);
    }
    old_data = 20;
    if (replace_matrix_int_by_value(&replace_matrix, old_data, new_data))
    {
        print_matrix(&replace_matrix);
    }
    else
    {
        printf("%d has not in matrix\n", old_data);
    }
    puts("----------------------------------------------------------------------------------------");
    puts("------------------------------------transpose matrix------------------------------------");
    int transpose_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixInt raw_matrix = {transpose_data, 5, 2};
    print_matrix(&raw_matrix);
    MatrixInt *transpose_matrix = transpose_matrix_int(&raw_matrix);
    print_matrix(transpose_matrix);
    return 0;
}