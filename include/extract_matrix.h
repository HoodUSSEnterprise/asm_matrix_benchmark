/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-20 15:35:34
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 09:09:38
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

#endif /* ifndef EXTRACT_MATRIX_H */
