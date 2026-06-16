/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 16:37:19
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 16:40:50
@FilePath: \asm_matrix_benchmark\include\sub_matrix.h
@Description:sub matrix head file
*************************************************************/
#ifndef SUB_MATRIX_H
#define SUB_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: sub matrix int value
@param {MatrixInt} *m1
@param {MatrixInt} *m2
@return {*}
 ************************************************************/
MatrixInt *sub_matrix_int(MatrixInt *m1, MatrixInt *m2);

#endif // SUB_MATRIX_H