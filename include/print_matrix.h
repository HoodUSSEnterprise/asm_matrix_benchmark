/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 15:36:19
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-21 12:56:06
@FilePath: \asm_matrix_benchmark\include\print_matrix.h
@Description:print matrix
*************************************************************/
#ifndef PRINT_MATRIX_H
#define PRINT_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: print matrix int
@param {MatrixInt} *m
@return {*}
*************************************************************/
void print_matrix_int(MatrixInt *m);

/***********************************************************
@description: print matrix double
@param {MatrixDouble} *m
@return {*}
 ************************************************************/
void print_matrix_double(MatrixDouble *m);

/***********************************************************
@description: print matrix float
@param {MatrixFloat} *m
@return {*}
************************************************************/
void print_matrix_float(MatrixFloat *m);

#endif // PRINT_MATRIX_H