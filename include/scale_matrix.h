/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 18:44:04
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 21:01:24
@FilePath: \asm_matrix_benchmark\include\scale_matrix.h
@Description: scale matrix head file
*************************************************************/
#ifndef SCALE_MATRIX_H
#define SCALE_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: scale matrix function
@param {MatrixInt} *m
@param {int} scale
@return {*}
 ************************************************************/
MatrixInt *scale_matrix_int(MatrixInt *m, int scale);

/***********************************************************
@description: scale matrix double function
@param {MatrixDouble} *m
@param {double} scale
@return {*}
*************************************************************/
MatrixDouble *scale_matrix_double(MatrixDouble *m, double scale);

/***********************************************************
@description: scale matrix float function
@param {MatrixFloat} *m
@param {float} scale
@return {*}
************************************************************/
MatrixFloat *scale_matrix_float(MatrixFloat *m, float scale);

#endif // SCALE_MATRIX_H