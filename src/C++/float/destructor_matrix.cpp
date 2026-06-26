/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:38:27
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:04:02
@FilePath: \asm_matrix_benchmark\src\C++\float\destructor_matrix.cpp
@Description: destructor of matrix
*************************************************************/

#include "matrix_float_cpp.h"

MatrixFloat::~MatrixFloat()
{
    // Free the underlying vector and reset dimensions
    data.clear();
    rows = 0;
    cols = 0;
}
