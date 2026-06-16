/************************************************************
 *@Author: HoodUSSEnterprise
 *@Date: 2026-06-15 20:51:36
 *@LastEditors: HoodUSSEnterprise
 *@LastEditTime: 2026-06-15 22:24:37
 *@FilePath: \asm_matrix\include\base_matrix.h
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

#endif // BASE_MATRIX_H