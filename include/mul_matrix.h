/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 16:45:15
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 16:05:14
@FilePath: \asm_matrix_benchmark\include\mul_matrix.h
@Description:mul matrix head file
*************************************************************/
#ifndef MUL_MATRIX_H
#define MUL_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: mul matrix function
@param {MatrixInt} *m1
@param {MatrixInt} *m2
@return {*}
 ************************************************************/
MatrixInt *mul_matrix_int(MatrixInt *m1, MatrixInt *m2);

/***********************************************************
@description: mul matrix float function
@param {MatrixFloat} *m1
@param {MatrixFloat} *m2
@return {*}
************************************************************/
MatrixFloat *mul_matrix_float(MatrixFloat *m1, MatrixFloat *m2);

/***********************************************************
@description: mul matrix double function
@param {MatrixDouble} *m1
@param {MatrixDouble} *m2
@return {*}
************************************************************/
MatrixDouble *mul_matrix_double(MatrixDouble *m1, MatrixDouble *m2);

#endif // MUL_MATRIX_H