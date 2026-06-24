/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 13:20:46
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-17 13:22:50
@FilePath: \asm_matrix_benchmark\include\replace_matrix.h
@Description:  replace matrix some data
*************************************************************/
#ifndef REPLACE_MATRIX_H
#define REPLACE_MATRIX_H

#include "base_matrix.h"
#include "find_matrix.h"

/***********************************************************
@description: replace matrix some data by coordinate
@param {MatrixInt} *m
@param {Point} *pos
@param {int} new_data
@return {*}
 ************************************************************/
bool replace_matrix_int_by_coord(MatrixInt *m, Point *pos, int new_data);

/***********************************************************
@description: replace matrix some data by value
@param {MatrixInt} *m
@param {int} old_data
@param {int} new_data
@return {*}
 ************************************************************/
bool replace_matrix_int_by_value(MatrixInt *m, int old_data, int new_data);

/***********************************************************
@description: replace matrix float some data by coordinate
@param {MatrixFloat} *m
@param {Point} *pos
@param {float} new_data
@return {*}
************************************************************/
bool replace_matrix_float_by_coord(MatrixFloat *m, Point *pos, float new_data);

/***********************************************************
@description: replace matrix float some data by value
@param {MatrixFloat} *m
@param {float} old_data
@param {float} new_data
@return {*}
************************************************************/
bool replace_matrix_float_by_value(MatrixFloat *m, float old_data, float new_data);

#endif // REPLACE_MATRIX_H