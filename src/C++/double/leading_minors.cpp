/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:26
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:50:58
@FilePath: \asm_matrix_benchmark\src\C++\double\leading_minors.cpp
@Description: leading principal minors c++ code
*************************************************************/

#include "matrix_double_cpp.h"
#include <stdexcept>

/***********************************************************
@description: Computes all leading principal minors of the matrix.
@return {*}
*************************************************************/
std::vector<MatrixDouble> MatrixDouble::leading_minors() const
{
    if (rows != cols)
    {
        throw std::invalid_argument("leading_minors: square matrix required");
    }

    std::vector<MatrixDouble> result;
    result.reserve(rows);

    // Extract leading principal submatrices of order 1..rows
    // Each submatrix is the top-left corner of the original matrix
    for (size_t order = 1; order <= rows; order++)
    {
        MatrixDouble sub(order, order);
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
