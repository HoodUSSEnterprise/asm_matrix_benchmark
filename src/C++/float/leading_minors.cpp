/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:26
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:05:49
@FilePath: \asm_matrix_benchmark\src\C++\float\leading_minors.cpp
@Description: leading principal minors c++ code
*************************************************************/

#include "matrix_float_cpp.h"
#include <stdexcept>

/***********************************************************
@description: Computes all leading principal minors of the matrix.
@return {*}
*************************************************************/
std::vector<MatrixFloat> MatrixFloat::leading_minors() const
{
    if (rows != cols)
    {
        throw std::invalid_argument("leading_minors: square matrix required");
    }

    std::vector<MatrixFloat> result;
    result.reserve(rows);

    // Extract leading principal submatrices of order 1..rows
    // Each submatrix is the top-left corner of the original matrix
    for (size_t order = 1; order <= rows; order++)
    {
        MatrixFloat sub(order, order);
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
