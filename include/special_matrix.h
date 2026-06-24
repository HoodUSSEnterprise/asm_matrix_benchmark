/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 17:12:21
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-17 17:21:57
@FilePath: \asm_matrix_benchmark\include\special_matrix.h
@Description: some special matrix like identity matrix, diag matrix, eye_matrix and zero matrix
*************************************************************/
#ifndef SPECIAL_MATRIX_H
#define SPECIAL_MATRIX_H

#include "base_matrix.h"

/***********************************************************
@description: generator identity matrix, every element type is int
@param {int} order
@return {*}
 ************************************************************/
MatrixInt *identity_matrix_int(int order);

/***********************************************************
@description: generator diag matrix, every element type is int
@param {int} *data
@param {size_t} len
@return {*}
 ************************************************************/
MatrixInt *diag_matrix_int(int *data, size_t len);

/***********************************************************
@description: generator eye matrix, every element type is int
@param {int} rows
@param {int} cols
@return {*}
 ************************************************************/
MatrixInt *eye_matrix_int(int rows, int cols);

/***********************************************************
@description: generator zero matrix, every element type is int
@param {int} rows
@param {int} cols
@return {*}
 ************************************************************/
MatrixInt *zero_matrix_int(int rows, int cols);

/***********************************************************
@description: generator identity matrix float
@param {int} order
@return {*}
************************************************************/
MatrixFloat *identity_matrix_float(int order);

/***********************************************************
@description: generator diag matrix float
@param {float} *data
@param {size_t} len
@return {*}
************************************************************/
MatrixFloat *diag_matrix_float(float *data, size_t len);

/***********************************************************
@description: generator eye matrix float
@param {int} rows
@param {int} cols
@return {*}
************************************************************/
MatrixFloat *eye_matrix_float(int rows, int cols);

/***********************************************************
@description: generator zero matrix float
@param {int} rows
@param {int} cols
@return {*}
************************************************************/
MatrixFloat *zero_matrix_float(int rows, int cols);

#endif // SPECIAL_MATRIX_H