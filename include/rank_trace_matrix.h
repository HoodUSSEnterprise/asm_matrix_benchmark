/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 19:37:37
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 14:46:00
@FilePath: \asm_matrix_benchmark\include\rank_trace_matrix.h
@Description:  rank and trace of matrix
*************************************************************/
#ifndef RANK_TRACE_MATRIX_H
#define RANK_TRACE_MATRIX_H

#include "base_matrix.h"
#include "transpose_matrix.h"
#include <stdbool.h>

/***********************************************************
@description: rank of matrix
@param {MatrixInt} *m
@param {int} *trace
@return {*}
 ************************************************************/
bool rank_matrix_int(MatrixInt *m, int *rank);

/***********************************************************
@description: trace of matrix
@param {MatrixInt} *m
@param {int} *trace
@return {*}
 ************************************************************/
bool trace_matrix_int(MatrixInt *m, int *trace);

/***********************************************************
@description: rank of matrix float
@param {MatrixFloat} *m
@param {int} *rank
@return {*}
*************************************************************/
bool rank_matrix_float(MatrixFloat *m, int *rank);

/***********************************************************
@description: trace of matrix float
@param {MatrixFloat} *m
@param {float} *trace
@return {*}
*************************************************************/
bool trace_matrix_float(MatrixFloat *m, float *trace);

/***********************************************************
@description: rank of matrix double
@param {MatrixDouble} *m
@param {int} *rank
@return {*}
*************************************************************/
bool rank_matrix_double(MatrixDouble *m, int *rank);

/***********************************************************
@description: trace of matrix double
@param {MatrixDouble} *m
@param {double} *trace
@return {*}
*************************************************************/
bool trace_matrix_double(MatrixDouble *m, double *trace);

#endif // RANK_TRACE_MATRIX_H