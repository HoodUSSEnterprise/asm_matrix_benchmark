/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:42:50
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-16 19:44:21
@FilePath: \asm_matrix_benchmark\src\C++\mul_matrix.cpp
@Description: mul matrix c++ code
*************************************************************/

#include "matrix_cpp.h"

/***********************************************************
@description: mul matrix function
@param {MatrixInt} m1
@param {MatrixInt} m2
@return {*}
 ************************************************************/
MatrixInt MatrixInt::mul_matrix(MatrixInt m1, MatrixInt m2)
{
    if (m1.cols != m2.rows)
    {
        throw std::invalid_argument("mul_matrix: inner dimensions must match");
    }

    MatrixInt res(m1.rows, m2.cols);
    for (size_t i = 0; i < m1.rows; ++i)
    {
        for (size_t j = 0; j < m2.cols; ++j)
        {
            long long sum = 0;
            for (size_t k = 0; k < m1.cols; ++k)
            {
                sum += static_cast<long long>(m1.data[i * m1.cols + k]) * m2.data[k * m2.cols + j];
            }
            res.data[i * res.cols + j] = static_cast<int>(sum);
        }
    }
    return res;
}