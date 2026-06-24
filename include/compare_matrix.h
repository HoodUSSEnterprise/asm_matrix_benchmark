/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-19 11:07:59
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 08:53:54
@FilePath: \asm_matrix_benchmark\include\compare_matrix.h
@Description: compare two matrix
*************************************************************/
#ifndef COMPARE_MATRIX_H
#define COMPARE_MATRIX_H

#include "base_matrix.h"
#include <stdbool.h>

extern const double eps;

/***********************************************************
@description: compare two matrix both int type
@param {MatrixInt} *m1
@param {MatrixInt} *m2
@return {*}
 ************************************************************/
bool is_equal_matrix_int(MatrixInt *m1, MatrixInt *m2);

/***********************************************************
@description: compare two matrix both double type
@param {MatrixDouble} *m1
@param {MatrixDouble} *m2
@return {*}
*************************************************************/
bool is_equal_matrix_double(MatrixDouble *m1, MatrixDouble *m2);

/***********************************************************
@description: compare two matrix both float type
@param {MatrixFloat} *m1
@param {MatrixFloat} *m2
@return {*}
************************************************************/
bool is_equal_matrix_float(MatrixFloat *m1, MatrixFloat *m2);

#endif // COMPARE_MATRIX_H