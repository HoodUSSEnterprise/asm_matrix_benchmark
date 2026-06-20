/************************************************************
 *@Author: HoodUSSEnterprise
 *@Date: 2026-06-15 20:51:36
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-20 13:33:08
@FilePath: \asm_matrix_benchmark\include\base_matrix.h
 *@Description:Define struct matrix
 *************************************************************/

#ifndef BASE_MATRIX_H
#define BASE_MATRIX_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct MatrixInt
{
    int *data;
    size_t rows;
    size_t cols;
} MatrixInt;

typedef struct MatrixFloat
{
    float *data;
    size_t rows;
    size_t cols;
} MatrixFloat;

typedef struct MatrixDouble
{
    double *data;
    size_t rows;
    size_t cols;
} MatrixDouble;

#endif // BASE_MATRIX_H