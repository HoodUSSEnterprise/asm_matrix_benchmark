/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:38:27
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:40:03
@FilePath: \asm_matrix_benchmark\src\C++\destructor_matrix.cpp
@Description: destructor of matrix
*************************************************************/
#include "matrix_cpp.h"

MatrixInt::~MatrixInt()
{
    cleanup();
}

void MatrixInt::cleanup()
{
    data.clear();
    rows = 0;
    cols = 0;
}
