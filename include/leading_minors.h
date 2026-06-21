/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-21 15:42:01
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-21 15:45:04
@FilePath: \asm_matrix_benchmark\include\leading_minors.h
@Description: get leading principal minor
*************************************************************/
#ifndef LEADING_MINORS_H
#define LEADING_MINORS_H

#include "base_matrix.h"

typedef struct Leading_Minors_Int
{
    MatrixInt *matrix_data;
    size_t len;
} Leading_Minors_Int;

/***********************************************************
@description: get leading principal minor
@param {MatrixInt} *m
@return {*}
 ************************************************************/
Leading_Minors_Int *get_leading_minors_int(MatrixInt *m);

#endif // LEADING_MINORS_H