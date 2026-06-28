/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-27 19:55:02
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-28 08:51:08
@FilePath: \asm_matrix_benchmark\include\determinant_matrix.h
@Description: determinant of matrix
*************************************************************/
#ifndef DETERMINANT_MATRIX_H
#define DETERMINANT_MATRIX_H

#include "base_matrix.h"
#include <stdbool.h>

/***********************************************************
@description: determinant of MatrixInt
@param {MatrixInt} *m
@param {int} *det
@return {*}
*************************************************************/
bool determinant_int(MatrixInt *m, int *det);

/***********************************************************
@description: determinant of MatrixFloat
@param {MatrixFloat} *m
@param {double} *det
@return {*}
*************************************************************/
bool determinant_float(MatrixFloat *m, double *det);

/***********************************************************
@description: determinant of MatrixDouble
@param {MatrixDouble} *m
@param {double} *det
@return {*}
*************************************************************/
bool determinant_double(MatrixDouble *m, double *det);

#endif // DETERMINANT_MATRIX_H