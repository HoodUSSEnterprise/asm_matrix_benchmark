/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-20 15:35:34
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 15:58:42
@FilePath: \asm_matrix_benchmark\include\extract_matrix.h
@Description: extract matrix rows, cols or diags
*************************************************************/

#ifndef EXTRACT_MATRIX_H
#define EXTRACT_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: extract matrix's row
@param {MatrixInt} *m
@param {size_t} index
@return {*}
*************************************************************/
MatrixInt *extract_row_int(MatrixInt *m, size_t index);

/***********************************************************
@description: extract matrix's col
@param {MatrixInt} *m
@param {size_t} index
@return {*}
*************************************************************/
MatrixInt *extract_col_int(MatrixInt *m, size_t index);

/***********************************************************
@description: extract matrix's diag
@param {MatrixInt} *m
@return {*}
*************************************************************/
int *extract_diag_int(MatrixInt *m);

/***********************************************************
@description: extract matrix's row float
@param {MatrixFloat} *m
@param {size_t} index
@return {*}
*************************************************************/
MatrixFloat *extract_row_float(MatrixFloat *m, size_t index);

/***********************************************************
@description: extract matrix's col float
@param {MatrixFloat} *m
@param {size_t} index
@return {*}
*************************************************************/
MatrixFloat *extract_col_float(MatrixFloat *m, size_t index);

/***********************************************************
@description: extract matrix's diag float
@param {MatrixFloat} *m
@return {*}
*************************************************************/
float *extract_diag_float(MatrixFloat *m);

/***********************************************************
@description: extract matrix's row double
@param {MatrixDouble} *m
@param {size_t} index
@return {*}
*************************************************************/
MatrixDouble *extract_row_double(MatrixDouble *m, size_t index);

/***********************************************************
@description: extract matrix's col double
@param {MatrixDouble} *m
@param {size_t} index
@return {*}
*************************************************************/
MatrixDouble *extract_col_double(MatrixDouble *m, size_t index);

/***********************************************************
@description: extract matrix's diag double
@param {MatrixDouble} *m
@return {*}
*************************************************************/
double *extract_diag_double(MatrixDouble *m);

#endif /* ifndef EXTRACT_MATRIX_H */
