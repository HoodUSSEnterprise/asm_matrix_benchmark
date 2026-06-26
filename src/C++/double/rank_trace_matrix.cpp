/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:22
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:54:19
@FilePath: \asm_matrix_benchmark\src\C++\double\rank_trace_matrix.cpp
@Description: rank and trace matrix c++ code
*************************************************************/

#include "matrix_double_cpp.h"
#include <algorithm>
#include <cmath>

/***********************************************************
@description: calc rank of matrix
@return {*}
*************************************************************/
size_t MatrixDouble::rank() const
{
    if (rows == 0 || cols == 0)
    {
        return 0;
    }

    // Copy to 2D vector for Gaussian elimination
    std::vector<std::vector<double>> mat(rows);
    for (size_t i = 0; i < rows; i++)
    {
        mat[i].resize(cols);
        for (size_t j = 0; j < cols; j++)
        {
            mat[i][j] = data[i * cols + j];
        }
    }

    size_t r = 0;
    for (size_t col = 0; col < cols && r < rows; col++)
    {
        // Find pivot: first row (at or below current) with non-zero entry in this column
        size_t pivot = r;
        while (pivot < rows && std::fabs(mat[pivot][col]) < 1e-12)
        {
            pivot++;
        }
        if (pivot == rows)
        {
            continue;
        }

        // Swap pivot row up to current rank position
        std::swap(mat[r], mat[pivot]);

        // Eliminate rows below using the pivot row
        for (size_t i = r + 1; i < rows; i++)
        {
            if (std::fabs(mat[i][col]) >= 1e-12)
            {
                double factor = mat[i][col] / mat[r][col];
                for (size_t j = col; j < cols; j++)
                {
                    mat[i][j] -= factor * mat[r][j];
                }
            }
        }
        r++;
    }
    // Rank equals the number of non-zero rows in row-echelon form
    return r;
}

/***********************************************************
@description: calc trace of matrix
@return {*}
*************************************************************/
double MatrixDouble::trace() const
{
    if (rows != cols)
    {
        throw std::invalid_argument("trace: square matrix required");
    }
    // Sum of diagonal elements A[0][0] + A[1][1] + ... + A[n-1][n-1]
    int sum = 0;
    for (size_t i = 0; i < rows; i++)
    {
        sum += data[i * cols + i];
    }
    return sum;
}
