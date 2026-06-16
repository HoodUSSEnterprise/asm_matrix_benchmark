/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:42:58
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:43:22
@FilePath: \asm_matrix_benchmark\src\C++\scale_matrix.cpp
@Description: scale matrix c++ code
*************************************************************/
#include "matrix_cpp.h"

/***********************************************************
@description: scale matrix
@param {MatrixInt} m1
@param {int} m2
@return {*}
 ************************************************************/
MatrixInt MatrixInt::scale_matrix(MatrixInt m1, int m2)
{
    MatrixInt res(m1.rows, m1.cols);
    for (size_t i = 0; i < m1.rows * m1.cols; ++i)
    {
        res.data[i] = m1.data[i] * m2;
    }
    return res;
}