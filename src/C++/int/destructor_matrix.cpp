/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:38:27
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:56:28
@FilePath: \asm_matrix_benchmark\src\C++\int\destructor_matrix.cpp
@Description: destructor of matrix
*************************************************************/

#include "matrix_int_cpp.h"

MatrixInt::~MatrixInt()
{
    // Free the underlying vector and reset dimensions
    data.clear();
    rows = 0;
    cols = 0;
}
