/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 15:40:24
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 14:49:48
@FilePath: \asm_matrix_benchmark\include\transpose_matrix.h
@Description: transpose the matrix
*************************************************************/
#ifndef TRANSPOSE_MATRIX_H
#define TRANSPOSE_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: transpose the matrix
@param {MatrixInt} *m
@return {*}
 ************************************************************/
MatrixInt *transpose_matrix_int(MatrixInt *m);

/***********************************************************
@description: transpose the matrix
@param {MatrixInt} *m
@return {*}
*************************************************************/
MatrixDouble *transpose_matrix_double(MatrixDouble *m);

#endif // TRANSPOSE_MATRIX_H