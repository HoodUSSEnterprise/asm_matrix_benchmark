/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 20:51:54
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 22:41:29
@FilePath: \asm_matrix_benchmark\include\cat_matrix.h
@Description:
*************************************************************/
#ifndef CAT_MATRIX_H
#define CAT_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: cat matrix, axis : 1 means horizon, 0 means vertical
@param {MatrixInt} *m1
@param {MatrixInt} *m2
@param {int} axis : 1 means horizon, 0 means vertical
@return {*}
 ************************************************************/
MatrixInt *cat_matrix_int(MatrixInt *m1, MatrixInt *m2, int axis);

/***********************************************************
@description: cat matrix double, axis : 1 means horizon, 0 means vertical
@param {MatrixDouble} *m1
@param {MatrixDouble} *m2
@param {int} axis : 1 means horizon, 0 means vertical
@return {*}
************************************************************/
MatrixDouble *cat_matrix_double(MatrixDouble *m1, MatrixDouble *m2, int axis);

#endif // CAT_MATRIX_H