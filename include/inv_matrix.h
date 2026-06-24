/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-20 13:31:57
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 15:59:13
@FilePath: \asm_matrix_benchmark\include\inv_matrix.h
@Description: calculation of invertible matrix
*************************************************************/
#ifndef INV_MATRIX_H
#define INV_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: invertible matrix
@param {MatrixInt} *m
@return {*}
 ************************************************************/
MatrixDouble *inv_matrix_int(MatrixInt *m);

/***********************************************************
@description: invertible matrix float
@param {MatrixFloat} *m
@return {*}
************************************************************/
MatrixFloat *inv_matrix_float(MatrixFloat *m);

/***********************************************************
@description: invertible matrix double
@param {MatrixDouble} *m
@return {*}
************************************************************/
MatrixDouble *inv_matrix_double(MatrixDouble *m);

#endif // INV_MATRIX_H