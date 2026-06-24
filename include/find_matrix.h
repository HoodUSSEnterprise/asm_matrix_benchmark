/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-17 10:12:40
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-24 14:37:37
@FilePath: \asm_matrix_benchmark\include\find_matrix.h
@Description: find elem position in matrix
*************************************************************/
#ifndef FIND_MATRIX_H
#define FIND_MATRIX_H

#include "base_matrix.h"
#include <stdbool.h>

typedef struct Point
{
    size_t x;
    size_t y;
} Point;

/***********************************************************
@description: find elem position in matrix m
@param {MatrixInt} *m
@param {int} elem
@param {Point} *pos
@return {*}
 ************************************************************/
bool find_elem_int(MatrixInt *m, int elem, Point *pos);

/***********************************************************
@description: find elem position in matrix m
@param {MatrixDouble} *m
@param {double} elem
@param {Point} *pos
@return {*}
*************************************************************/
bool find_elem_double(MatrixDouble *m, double elem, Point *pos);

/***********************************************************
@description: find elem position in matrix m
@param {MatrixFloat} *m
@param {float} elem
@param {Point} *pos
@return {*}
*************************************************************/
bool find_elem_float(MatrixFloat *m, float elem, Point *pos);

#endif // FIND_MATRIX_H