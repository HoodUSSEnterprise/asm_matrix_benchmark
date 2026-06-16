/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:25:31
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:46:08
@FilePath: \asm_matrix_benchmark\src\C++\add_matrix.cpp
@Description: add matrix c++ code
*************************************************************/
#include "matrix_cpp.h"
#include <stdexcept>

/***********************************************************
@description: add matrix function
@param {MatrixInt} m1
@param {MatrixInt} m2
@return {*}
 ************************************************************/
MatrixInt MatrixInt::add_matrix(MatrixInt m1, MatrixInt m2)
{
    if (m1.rows != m2.rows || m1.cols != m2.cols)
    {
        throw std::invalid_argument("add_matrix: dimension mismatch");
    }

    MatrixInt res(m1.rows, m1.cols);
    for (size_t i = 0; i < m1.rows * m1.cols; ++i)
    {
        res.data[i] = m1.data[i] + m2.data[i];
    }
    return res;
}
