/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-21 14:10:23
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-21 15:58:18
@FilePath: \asm_matrix_benchmark\include\lu_matrix.h
@Description: lu decomposition of matrix
*************************************************************/
#ifndef LU_MATRIX_H
#define LU_MATRIX_H

#include "base_matrix.h"
#include "leading_minors.h"
#include "rank_trace_matrix.h"

typedef struct LU_Result
{
    MatrixDouble *L;
    MatrixDouble *U;
} LU_Result;

/***********************************************************
@description: lu decomposition of matrix
@param {MatrixInt} *m
@param {LU_Result} *res
@return {*}
 ************************************************************/
bool LU_Decomposition_int(MatrixInt *m, LU_Result *res);

/***********************************************************
@description: lu decomposition of matrix double
@param {MatrixDouble} *m
@param {LU_Result} *res
@return {*}
************************************************************/
bool LU_Decomposition_double(MatrixDouble *m, LU_Result *res);

#endif // LU_MATRIX_H