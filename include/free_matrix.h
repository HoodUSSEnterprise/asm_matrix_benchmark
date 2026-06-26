/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-25 16:24:13
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-25 16:28:06
@FilePath: \asm_matrix_benchmark\include\free_matrix.h
@Description: free matrix head file
*************************************************************/
#ifndef FREE_MATRIX_H
#define FREE_MATRIX_H

#include "base_matrix.h"
#include "leading_minors.h"

/***********************************************************
@description: free matrix int
@param {MatrixInt} *
@return {*}
*************************************************************/
void free_matrix_int(MatrixInt **m);

/***********************************************************
@description: free matrix float
@param {MatrixFloat} *
@return {*}
*************************************************************/
void free_matrix_float(MatrixFloat **m);

/***********************************************************
@description: free matrix double
@param {MatrixDouble} *
@return {*}
*************************************************************/
void free_matrix_double(MatrixDouble **m);

/***********************************************************
@description: free leading principal minor int
@param {Leading_Minors_Int} *
@return {*}
*************************************************************/
void free_leading_minors_int(Leading_Minors_Int **l);

/***********************************************************
@description: free leading principal minor float
@param {Leading_Minors_Float} *
@return {*}
*************************************************************/
void free_leading_minors_float(Leading_Minors_Float **l);

/***********************************************************
@description: free leading principal minor double
@param {Leading_Minors_Double} *
@return {*}
*************************************************************/
void free_leading_minors_double(Leading_Minors_Double **l);

#endif // FREE_MATRIX_H