/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 13:26:46
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-29 13:52:47
@FilePath: \asm_matrix_benchmark\src\C++\float\lu_matrix.cpp
@Description:LU decomposition for MatrixFloat (C++ version, converts to double internally)
*************************************************************/

#include "matrix_float_cpp.h"
#include <iostream>
#include <vector>

/***********************************************************
@description: LU decomposition using Doolittle method.
Internal computation uses double precision.
Returns [L, U] where L is unit lower triangular,
U is upper triangular (both as MatrixDouble).
@return vector with 2 elements: [L, U], or empty on failure
*************************************************************/
std::vector<MatrixDouble> MatrixFloat::LU_Decomposition()
{
    // Check square
    if (rows != cols)
    {
        std::cerr << "It's not a square" << std::endl;
        return {};
    }

    // Check all leading minors have full rank
    auto minors = leading_minors();
    for (size_t i = 0; i < minors.size(); i++)
    {
        if (minors[i].rank() != i + 1)
        {
            std::cerr << "This matrix can't lu decomposition" << std::endl;
            return {};
        }
    }

    size_t n = rows;
    MatrixDouble L(n, n);
    MatrixDouble U(n, n);

    // L upper triangle: 1 on diagonal, 0 above
    for (size_t i = 0; i < n; i++)
    {
        L(i, i) = 1.0;
    }

    // u_{0j} = a_{0j} (convert to double)
    for (size_t j = 0; j < n; j++)
    {
        U(0, j) = static_cast<double>(data[j]);
    }

    // l_{i0} = a_{i0} / u_{00}
    for (size_t i = 1; i < n; i++)
    {
        L(i, 0) = static_cast<double>(data[i * n]) / U(0, 0);
    }

    for (size_t k = 1; k < n; k++)
    {
        for (size_t j = k; j < n; j++)
        {
            double sum = 0.0;
            for (size_t t = 0; t < k; t++)
            {
                sum += L(k, t) * U(t, j);
            }
            U(k, j) = static_cast<double>(data[k * n + j]) - sum;
        }

        for (size_t i = k + 1; i < n; i++)
        {
            double sum = 0.0;
            for (size_t t = 0; t < k; t++)
            {
                sum += L(i, t) * U(t, k);
            }
            L(i, k) = (static_cast<double>(data[i * n + k]) - sum) / U(k, k);
        }
    }

    std::vector<MatrixDouble> result;
    result.push_back(L);
    result.push_back(U);
    return result;
}
