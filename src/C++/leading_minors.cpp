/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:26
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:41:31
@FilePath: \asm_matrix_benchmark\src\C++\leading_minors.cpp
@Description: leading principal minors c++ code
*************************************************************/
#include "matrix_cpp.h"
#include <stdexcept>

/***********************************************************
@description: Computes all leading principal minors of the matrix.
@return {*}
*************************************************************/
std::vector<MatrixInt> MatrixInt::leading_minors() const
{
    if (rows != cols)
    {
        throw std::invalid_argument("leading_minors: square matrix required");
    }

    std::vector<MatrixInt> result;
    result.reserve(rows);

    for (size_t order = 1; order <= rows; order++)
    {
        MatrixInt sub(order, order);
        for (size_t i = 0; i < order; i++)
        {
            for (size_t j = 0; j < order; j++)
            {
                sub(i, j) = data[i * cols + j];
            }
        }
        result.push_back(std::move(sub));
    }
    return result;
}
