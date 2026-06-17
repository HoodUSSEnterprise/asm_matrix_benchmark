/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 19:37:37
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-17 19:38:28
@FilePath: \asm_matrix_benchmark\include\rank_trace_matrix.h
@Description:  rank and trace of matrix
*************************************************************/
#ifndef RANK_TRACE_MATRIX_H
#define RANK_TRACE_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: rank of matrix
@param {MatrixInt} *m
@return {*}
 ************************************************************/
int rank_matrix(MatrixInt *m);

/***********************************************************
@description: trace of matrix
@param {MatrixInt} *m
@return {*}
 ************************************************************/
int trace_matrix(MatrixInt *m);

#endif // RANK_TRACE_MATRIX_H