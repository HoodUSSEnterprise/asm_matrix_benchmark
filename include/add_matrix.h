/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-15 20:50:55
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:56:01
@FilePath: \asm_matrix_benchmark\include\add_matrix.h
@Description: This is a header file that add matrix.
*************************************************************/
#ifndef ADD_MATRIX_H
#define ADD_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: add matrix int
@param {MatrixInt} *m1
@param {MatrixInt} *m2
@return {*}
 ************************************************************/
MatrixInt *add_matrix_int(MatrixInt *m1, MatrixInt *m2);

/***********************************************************
@description: add matrix double
@param {MatrixDouble} *m1
@param {MatrixDouble} *m2
@return {*}
*************************************************************/
MatrixDouble *add_matrix_double(MatrixDouble *m1, MatrixDouble *m2);

#endif // ADD_MATRIX_H