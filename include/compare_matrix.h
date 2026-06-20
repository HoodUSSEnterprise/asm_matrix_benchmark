/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-19 11:07:59
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-19 11:10:44
@FilePath: \asm_matrix_benchmark\include\compare_matrix.h
@Description: compare two matrix
*************************************************************/
#ifndef COMPARE_MATRIX_H
#define COMPARE_MATRIX_H

#include "base_matrix.h"
#include <stdbool.h>

/***********************************************************
@description: compare two matrix both int type
@param {MatrixInt} *m1
@param {MatrixInt} *m2
@return {*}
 ************************************************************/
bool is_equal_matrix_int(MatrixInt *m1, MatrixInt *m2);

#endif // COMPARE_MATRIX_H