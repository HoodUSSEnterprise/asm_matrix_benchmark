/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-21 20:16:43
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-21 20:22:03
@FilePath: \asm_matrix_benchmark\include\random_matrix.h
@Description: randome matrix int
*************************************************************/
#ifndef RANDOM_MATRIX_H
#define RANDOM_MATRIX_H

#include "base_matrix.h"
#include <time.h>

/***********************************************************
@description: random matrix
@param {size_t} rows
@param {size_t} cols
@param {int} range must contains two number
@return {*}
 ************************************************************/
MatrixInt *random_matrix_int(size_t rows, size_t cols, int *range, size_t size);

/***********************************************************
@description: random matrix float
@param {size_t} rows
@param {size_t} cols
@param {float} range must contains two number
@return {*}
************************************************************/
MatrixFloat *random_matrix_float(size_t rows, size_t cols, float *range, size_t size);

#endif // RANDOM_MATRIX_H