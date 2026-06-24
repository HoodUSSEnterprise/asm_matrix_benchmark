/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-24 15:30:00
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 15:30:00
@FilePath: \asm_matrix_benchmark\example\matrix_float.c
@Description:example of matrix float
*************************************************************/

#include "matrix.h"

int main(void)
{
    float data[4] = {1, 2, 3, 4};
    MatrixFloat v1 = {data, 2, 2};
    MatrixFloat v2 = {data, 1, 4};
    MatrixFloat v3 = {data, 2, 2};
    // add matrix example
    puts("---------------------------------------add matrix---------------------------------------");
    MatrixFloat *v = add_matrix_float(&v1, &v2);
    MatrixFloat *m = add_matrix_float(&v1, &v3);
    print_matrix_float(v);
    print_matrix_float(m);
    puts("----------------------------------------------------------------------------------------");
    puts("---------------------------------------sub matrix---------------------------------------");
    v = sub_matrix_float(&v1, &v2);
    m = sub_matrix_float(&v1, &v3);
    print_matrix_float(v);
    print_matrix_float(m);
    puts("----------------------------------------------------------------------------------------");
    puts("---------------------------------------mul matrix---------------------------------------");
    float mul_data[3] = {1, 2, 3};
    MatrixFloat mul1 = {mul_data, 3, 1};
    MatrixFloat mul2 = {mul_data, 1, 3};
    m = mul_matrix_float(&mul1, &mul2);
    print_matrix_float(m);
    puts("----------------------------------------------------------------------------------------");
    puts("--------------------------------------scale matrix--------------------------------------");
    float scale_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixFloat scale = {scale_data, 2, 5};
    print_matrix_float(&scale);
    m = scale_matrix_float(&scale, 2);
    print_matrix_float(m);
    puts("----------------------------------------------------------------------------------------");
    puts("---------------------------------------cat matrix---------------------------------------");
    float cat_data1[3] = {1, 2, 3};
    float cat_data2[6] = {4, 5, 6, 7, 8, 9};
    MatrixFloat cat_matrix1 = {cat_data1, 1, 3};
    MatrixFloat cat_matrix2 = {cat_data2, 2, 3};
    m = cat_matrix_float(&cat_matrix1, &cat_matrix2, 0);
    print_matrix_float(m);
    MatrixFloat cat_matrix3 = {cat_data1, 3, 1};
    MatrixFloat cat_matrix4 = {cat_data2, 3, 2};
    m = cat_matrix_float(&cat_matrix3, &cat_matrix4, 1);
    print_matrix_float(m);
    puts("----------------------------------------------------------------------------------------");
    puts("--------------------------------------find matrix---------------------------------------");
    float find_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixFloat find_matrix = {find_data, 5, 2};
    print_matrix_float(&find_matrix);
    Point p = {0, 0};
    float find_elem = 5;
    if (find_elem_float(&find_matrix, find_elem, &p))
    {
        puts("find elem");
        printf("Position is (%zu, %zu)\n", p.x, p.y);
    }
    else
    {
        printf("No find elem : %f\n", find_elem);
    }
    find_elem = 11;
    if (find_elem_float(&find_matrix, find_elem, &p))
    {
        puts("find elem");
        printf("Position is (%zu, %zu)\n", p.x, p.y);
    }
    else
    {
        printf("No find elem : %f\n", find_elem);
    }
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------replace matrix-------------------------------------");
    float replace_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixFloat replace_matrix = {replace_data, 5, 2};
    Point replace_pos = {10, 2};
    if (replace_matrix_float_by_coord(&replace_matrix, &replace_pos, 10))
    {
        print_matrix_float(&replace_matrix);
    }
    else
    {
        printf("(%zu, %zu) has out of index range\n", replace_pos.x, replace_pos.y);
    }
    replace_pos = (Point){0, 0};
    if (replace_matrix_float_by_coord(&replace_matrix, &replace_pos, 10))
    {
        print_matrix_float(&replace_matrix);
    }
    else
    {
        printf("(%zu, %zu) has out of index range\n", replace_pos.x, replace_pos.y);
    }
    float old_data_f = 7;
    float new_data_f = 10;
    if (replace_matrix_float_by_value(&replace_matrix, old_data_f, new_data_f))
    {
        print_matrix_float(&replace_matrix);
    }
    else
    {
        printf("%f has not in matrix\n", old_data_f);
    }
    old_data_f = 20;
    if (replace_matrix_float_by_value(&replace_matrix, old_data_f, new_data_f))
    {
        print_matrix_float(&replace_matrix);
    }
    else
    {
        printf("%f has not in matrix\n", old_data_f);
    }
    puts("----------------------------------------------------------------------------------------");
    puts("------------------------------------transpose matrix------------------------------------");
    float transpose_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixFloat raw_matrix = {transpose_data, 5, 2};
    print_matrix_float(&raw_matrix);
    MatrixFloat *transpose_matrix = transpose_matrix_float(&raw_matrix);
    print_matrix_float(transpose_matrix);
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------special matrix-------------------------------------");
    MatrixFloat *identity = identity_matrix_float(6);
    print_matrix_float(identity);
    float diag_data[5] = {1, 2, 3, 4, 5};
    MatrixFloat *diag = diag_matrix_float(diag_data, 5);
    print_matrix_float(diag);
    MatrixFloat *eye = eye_matrix_float(3, 4);
    print_matrix_float(eye);
    MatrixFloat *zero = zero_matrix_float(10, 10);
    print_matrix_float(zero);
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------rank and trace-------------------------------------");
    float rank_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    MatrixFloat rank_matrix = {rank_data, 3, 3};
    int rank = 0;
    if (rank_matrix_float(&rank_matrix, &rank))
    {
        print_matrix_float(&rank_matrix);
        printf("matrix rank = %d \n", rank);
    }
    MatrixFloat trace_matrix = {rank_data, 3, 3};
    float trace = 0;
    if (trace_matrix_float(&trace_matrix, &trace))
    {
        print_matrix_float(&trace_matrix);
        printf("matrix trace = %f \n", trace);
    }
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------compare matrix-------------------------------------");
    float compare_data1[6] = {1, 2, 3, 4, 5, 6};
    float compare_data2[6] = {6, 5, 4, 3, 2, 1};
    MatrixFloat compare_matrix1 = {compare_data1, 2, 3};
    MatrixFloat compare_matrix2 = {compare_data1, 2, 3};
    MatrixFloat compare_matrix3 = {compare_data2, 2, 3};
    MatrixFloat compare_matrix4 = {compare_data1, 3, 2};
    if (is_equal_matrix_float(&compare_matrix1, &compare_matrix2))
    {
        puts("Two matrix equals\n");
    }
    else
    {
        puts("Two matrix not equals\n");
    }
    if (is_equal_matrix_float(&compare_matrix1, &compare_matrix3))
    {
        puts("Two matrix equals\n");
    }
    else
    {
        puts("Two matrix not equals\n");
    }
    if (is_equal_matrix_float(&compare_matrix1, &compare_matrix4))
    {
        puts("Two matrix equals\n");
    }
    else
    {
        puts("Two matrix not equals\n");
    }
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------invertible matrix-------------------------------------");
    float inv_data[9] = {1, 2, 3, 0, 4, 5, 1, 0, 6};
    MatrixFloat matrix_origin = {inv_data, 3, 3};
    MatrixFloat *matrix_inv = inv_matrix_float(&matrix_origin);
    print_matrix_float(matrix_inv);
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------leading minors-------------------------------------");
    float leading_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    MatrixFloat leading_matrix = {leading_data, 3, 3};
    Leading_Minors_Float *leading_minors = get_leading_minors_float(&leading_matrix);
    if (leading_minors != NULL)
    {
        for (size_t i = 0; i < leading_minors->len; i++)
        {
            print_matrix_float(&leading_minors->matrix_data[i]);
        }
    }
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------extract matrix--------------------------------------");
    float extract_data[6] = {1, 2, 3, 4, 5, 6};
    MatrixFloat extract_matrix = {extract_data, 2, 3};
    print_matrix_float(&extract_matrix);
    MatrixFloat *extract_row = extract_row_float(&extract_matrix, 0);
    print_matrix_float(extract_row);
    MatrixFloat *extract_col = extract_col_float(&extract_matrix, 1);
    print_matrix_float(extract_col);
    puts("extract diag: ");
    float *extract_diag = extract_diag_float(&extract_matrix);
    for (size_t i = 0; i < 2; i++)
    {
        printf("%f ", extract_diag[i]);
    }
    puts("");
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------random matrix---------------------------------------");
    MatrixFloat *rand_matrix1 = random_matrix_float(3, 4, NULL, 0);
    print_matrix_float(rand_matrix1);
    float rand_range[2] = {5, 15};
    MatrixFloat *rand_matrix2 = random_matrix_float(2, 5, rand_range, 2);
    print_matrix_float(rand_matrix2);
    float rand_range2[2] = {20, 10};
    MatrixFloat *rand_matrix3 = random_matrix_float(4, 3, rand_range2, 2);
    print_matrix_float(rand_matrix3);
    puts("----------------------------------------------------------------------------------------");
    return 0;
}
