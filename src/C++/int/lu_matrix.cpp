/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-29 13:26:45
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-29 13:52:14
@FilePath: \asm_matrix_benchmark\src\C++\int\lu_matrix.cpp
@Description: LU decomposition for MatrixInt (C++ version)
*************************************************************/

#include "matrix_int_cpp.h"
#include <iostream>
#include <vector>

/***********************************************************
@description: LU decomposition using Doolittle method.
Returns [L, U] where L is unit lower triangular,
U is upper triangular (both as MatrixDouble).
@return vector with 2 elements: [L, U], or empty on failure
*************************************************************/
std::vector<MatrixDouble> MatrixInt::LU_Decomposition()
{
    // Check square
    if (rows != cols)
    {
        std::cerr << "It's not a square" << std::endl;
        return {};
    }

    // Check all leading minors have full rank (LU condition)
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

    // Allocate L and U as double matrices, initialised to 0
    MatrixDouble L(n, n);
    MatrixDouble U(n, n);

    // Init L upper triangle: L(i,j) = 1 if i==j else 0
    for (size_t i = 0; i < n; i++)
    {
        L(i, i) = 1.0;
    }

    // Doolittle algorithm
    // u_{1j} = a_{1j},  j = 0:n-1
    for (size_t j = 0; j < n; j++)
    {
        U(0, j) = static_cast<double>(data[j]);
    }

    // l_{i1} = a_{i1} / u_{11},  i = 1:n-1
    for (size_t i = 1; i < n; i++)
    {
        L(i, 0) = static_cast<double>(data[i * n]) / U(0, 0);
    }

    // For k = 1:n-1:
    //   u_{kj} = a_{kj} - sum_{t=0}^{k-1} l_{kt} * u_{tj},  j = k:n-1
    //   l_{ik} = (a_{ik} - sum_{t=0}^{k-1} l_{it} * u_{tk}) / u_{kk},  i = k+1:n-1
    for (size_t k = 1; k < n; k++)
    {
        // Compute U row k, columns k..n-1
        for (size_t j = k; j < n; j++)
        {
            double sum = 0.0;
            for (size_t t = 0; t < k; t++)
            {
                sum += L(k, t) * U(t, j);
            }
            U(k, j) = static_cast<double>(data[k * n + j]) - sum;
        }

        // Compute L column k, rows k+1..n-1
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
