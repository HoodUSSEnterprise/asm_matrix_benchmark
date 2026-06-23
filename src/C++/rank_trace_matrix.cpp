/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:22
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:38:54
@FilePath: \asm_matrix_benchmark\src\C++\rank_trace_matrix.cpp
@Description: rank and trace matrix c++ code
*************************************************************/
#include "matrix_cpp.h"
#include <algorithm>
#include <cmath>

/***********************************************************
@description: calc rank of matrix
@return {*}
*************************************************************/
size_t MatrixInt::rank() const
{
    if (rows == 0 || cols == 0)
    {
        return 0;
    }

    // copy to 2D vector for elimination
    std::vector<std::vector<double>> mat(rows);
    for (size_t i = 0; i < rows; i++)
    {
        mat[i].resize(cols);
        for (size_t j = 0; j < cols; j++)
        {
            mat[i][j] = static_cast<double>(data[i * cols + j]);
        }
    }

    size_t r = 0;
    for (size_t col = 0; col < cols && r < rows; col++)
    {
        size_t pivot = r;
        while (pivot < rows && std::fabs(mat[pivot][col]) < 1e-12)
        {
            pivot++;
        }
        if (pivot == rows)
        {
            continue;
        }

        std::swap(mat[r], mat[pivot]);

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
    return r;
}

/***********************************************************
@description: calc trace of matrix
@return {*}
*************************************************************/
int MatrixInt::trace() const
{
    if (rows != cols)
    {
        throw std::invalid_argument("trace: square matrix required");
    }
    int sum = 0;
    for (size_t i = 0; i < rows; i++)
    {
        sum += data[i * cols + i];
    }
    return sum;
}
