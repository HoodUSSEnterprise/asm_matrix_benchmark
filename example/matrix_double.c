/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-24 14:33:44
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 14:41:16
@FilePath: \asm_matrix_benchmark\example\matrix_double.c
@Description: example of matrix double
*************************************************************/

#include "matrix.h"

int main(void)
{
    int data[4] = {1, 2, 3, 4};
    MatrixDouble v1 = {data, 2, 2};
    MatrixDouble v2 = {data, 1, 4};
    MatrixDouble v3 = {data, 2, 2};
    // add matrix example
    puts("---------------------------------------add matrix---------------------------------------");
    MatrixDouble *v = add_matrix_double(&v1, &v2);
    MatrixDouble *m = add_matrix_double(&v1, &v3);
    print_matrix_double(v);
    print_matrix_double(m);
    puts("----------------------------------------------------------------------------------------");
    puts("---------------------------------------sub matrix---------------------------------------");
    v = sub_matrix_double(&v1, &v2);
    m = sub_matrix_double(&v1, &v3);
    print_matrix_double(v);
    print_matrix_double(m);
    puts("----------------------------------------------------------------------------------------");
    puts("---------------------------------------mul matrix---------------------------------------");
    int mul_data[3] = {1, 2, 3};
    MatrixDouble mul1 = {mul_data, 3, 1};
    MatrixDouble mul2 = {mul_data, 1, 3};
    m = mul_matrix_double(&mul1, &mul2);
    print_matrix_double(m);
    puts("----------------------------------------------------------------------------------------");
    puts("--------------------------------------scale matrix--------------------------------------");
    int scale_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixDouble scale = {scale_data, 2, 5};
    print_matrix_double(&scale);
    m = scale_matrix_double(&scale, 2);
    print_matrix_double(m);
    puts("----------------------------------------------------------------------------------------");
    puts("---------------------------------------cat matrix---------------------------------------");
    int cat_data1[3] = {1, 2, 3};
    int cat_data2[6] = {4, 5, 6, 7, 8, 9};
    MatrixDouble cat_matrix1 = {cat_data1, 1, 3};
    MatrixDouble cat_matrix2 = {cat_data2, 2, 3};
    m = cat_matrix_double(&cat_matrix1, &cat_matrix2, 0);
    print_matrix_double(m);
    MatrixDouble cat_matrix3 = {cat_data1, 3, 1};
    MatrixDouble cat_matrix4 = {cat_data2, 3, 2};
    m = cat_matrix_double(&cat_matrix3, &cat_matrix4, 1);
    print_matrix_double(m);
    puts("----------------------------------------------------------------------------------------");
    puts("--------------------------------------find matrix---------------------------------------");
    int find_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixDouble find_matrix = {find_data, 5, 2};
    print_matrix_double(&find_matrix);
    Point p = {0, 0};
    int find_elem = 5;
    if (find_elem_double(&find_matrix, find_elem, &p))
    {
        puts("find elem");
        printf("Position is (%zu, %zu)\n", p.x, p.y);
    }
    else
    {
        printf("No find elem : %d\n", find_elem);
    }
    find_elem = 11;
    if (find_elem_double(&find_matrix, find_elem, &p))
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
    MatrixDouble replace_matrix = {replace_data, 5, 2};
    Point replace_pos = {10, 2};
    if (replace_matrix_int_by_coord(&replace_matrix, &replace_pos, 10))
    {
        print_matrix_double(&replace_matrix);
    }
    else
    {
        printf("(%zu, %zu) has out of index range\n", replace_pos.x, replace_pos.y);
    }
    replace_pos = (Point){0, 0};
    if (replace_matrix_int_by_coord(&replace_matrix, &replace_pos, 10))
    {
        print_matrix_double(&replace_matrix);
    }
    else
    {
        printf("(%zu, %zu) has out of index range\n", replace_pos.x, replace_pos.y);
    }
    int old_data = 7;
    int new_data = 10;
    if (replace_matrix_int_by_value(&replace_matrix, old_data, new_data))
    {
        print_matrix_double(&replace_matrix);
    }
    else
    {
        printf("%d has not in matrix\n", old_data);
    }
    old_data = 20;
    if (replace_matrix_int_by_value(&replace_matrix, old_data, new_data))
    {
        print_matrix_double(&replace_matrix);
    }
    else
    {
        printf("%d has not in matrix\n", old_data);
    }
    puts("----------------------------------------------------------------------------------------");
    puts("------------------------------------transpose matrix------------------------------------");
    int transpose_data[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    MatrixDouble raw_matrix = {transpose_data, 5, 2};
    print_matrix_double(&raw_matrix);
    MatrixDouble *transpose_matrix = transpose_matrix_double(&raw_matrix);
    print_matrix_double(transpose_matrix);
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------special matrix-------------------------------------");
    MatrixDouble *identity = identity_matrix_double(6);
    print_matrix_double(identity);
    int diag_data[5] = {1, 2, 3, 4, 5};
    MatrixDouble *diag = diag_matrix_double(diag_data, 5);
    print_matrix_double(diag);
    MatrixDouble *eye = eye_matrix_double(3, 4);
    print_matrix_double(eye);
    MatrixDouble *zero = zero_matrix_double(10, 10);
    print_matrix_double(zero);
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------rank and trace-------------------------------------");
    int rank_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    MatrixDouble rank_matrix = {rank_data, 3, 3};
    int rank = 0;
    if (rank_matrix_double(&rank_matrix, &rank))
    {
        print_matrix_double(&rank_matrix);
        printf("matrix rank = %d \n", rank);
    }
    MatrixDouble trace_matrix = {rank_data, 3, 3};
    int trace = 0;
    if (trace_matrix_double(&trace_matrix, &trace))
    {
        print_matrix_double(&trace_matrix);
        printf("matrix trace = %d \n", trace);
    }
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------compare matrix-------------------------------------");
    int compare_data1[6] = {1, 2, 3, 4, 5, 6};
    int compare_data2[6] = {6, 5, 4, 3, 2, 1};
    MatrixDouble compare_matrix1 = {compare_data1, 2, 3};
    MatrixDouble compare_matrix2 = {compare_data1, 2, 3};
    MatrixDouble compare_matrix3 = {compare_data2, 2, 3};
    MatrixDouble compare_matrix4 = {compare_data1, 3, 2};
    if (is_equal_matrix_double(&compare_matrix1, &compare_matrix2))
    {
        puts("Two matrix equals\n");
    }
    else
    {
        puts("Two matrix not equals\n");
    }
    if (is_equal_matrix_double(&compare_matrix1, &compare_matrix3))
    {
        puts("Two matrix equals\n");
    }
    else
    {
        puts("Two matrix not equals\n");
    }
    if (is_equal_matrix_double(&compare_matrix1, &compare_matrix4))
    {
        puts("Two matrix equals\n");
    }
    else
    {
        puts("Two matrix not equals\n");
    }
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------invertible matrix-------------------------------------");
    int inv_matrix[9] = {1, 2, 3, 0, 4, 5, 1, 0, 6};
    MatrixDouble matrix_orgin = {inv_matrix, 3, 3};
    MatrixDouble *matrix_inv = inv_matrix_double(&matrix_orgin);
    print_matrix_double(matrix_inv);
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------leading minors-------------------------------------");
    int leading_data[9] = {1, 2, 3, 4, 5, 6, 7, 8, 9};
    MatrixDouble leading_matrix = {leading_data, 3, 3};
    Leading_Minors_Double *leading_minors = get_leading_minors_double(&leading_matrix);
    if (leading_minors != NULL)
    {
        for (size_t i = 0; i < leading_minors->len; i++)
        {
            print_matrix_double(&leading_minors->matrix_data[i]);
        }
    }
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------lu decomposition-------------------------------------");
    int lu_data[9] = {1, 2, 3, 0, 4, 5, 1, 0, 6};
    MatrixDouble lu_matrix = {lu_data, 3, 3};
    LU_Result lu_res;
    if (LU_Decomposition_double(&lu_matrix, &lu_res))
    {
        print_matrix_double(lu_res.L);
        print_matrix_double(lu_res.U);
    }
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------extract matrix--------------------------------------");
    int extract_data[6] = {1, 2, 3, 4, 5, 6};
    MatrixDouble extract_matrix = {extract_data, 2, 3};
    print_matrix_double(&extract_matrix);
    MatrixDouble *extract_row = extract_row_double(&extract_matrix, 0);
    print_matrix_double(extract_row);
    MatrixDouble *extract_col = extract_col_double(&extract_matrix, 1);
    print_matrix_double(extract_col);
    puts("extract diag: ");
    int *extract_diag = extract_diag_double(&extract_matrix);
    for (size_t i = 0; i < 2; i++)
    {
        printf("%d ", extract_diag[i]);
    }
    puts("");
    puts("----------------------------------------------------------------------------------------");
    puts("-------------------------------------random matrix---------------------------------------");
    MatrixDouble *rand_matrix1 = random_matrix_double(3, 4, NULL, 0);
    print_matrix_double(rand_matrix1);
    int rand_range[2] = {5, 15};
    MatrixDouble *rand_matrix2 = random_matrix_double(2, 5, rand_range, 2);
    print_matrix_double(rand_matrix2);
    int rand_range2[2] = {20, 10};
    MatrixDouble *rand_matrix3 = random_matrix_double(4, 3, rand_range2, 2);
    print_matrix_double(rand_matrix3);
    puts("----------------------------------------------------------------------------------------");
    return 0;
}