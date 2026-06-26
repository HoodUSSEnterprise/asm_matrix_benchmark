/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-26 08:44:29
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:49:07
@FilePath: \asm_matrix_benchmark\src\C++\double\destructor_matrix.cpp
@Description: destructor of matrix
*************************************************************/

#include "matrix_double_cpp.h"

MatrixDouble::~MatrixDouble()
{
    // Free the underlying vector and reset dimensions
    data.clear();
    rows = 0;
    cols = 0;
}
