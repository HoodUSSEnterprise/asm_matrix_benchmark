/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-25 16:53:23
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:05:43
@FilePath: \asm_matrix_benchmark\src\C++\float\inv_matrix.cpp
@Description: invertible matrix c++ code
*************************************************************/

#include "matrix_float_cpp.h"
#include <cmath>
#include <stdexcept>

/***********************************************************
@description: invertible matrix
@return {*}
*************************************************************/
MatrixDouble MatrixFloat::inv_matrix() const
{
    if (rows != cols)
    {
        throw std::invalid_argument("leading_minors: square matrix required");
    }

    // Build augmented matrix [A | I]: left side is A copied from data,
    // right side is the identity matrix
    std::vector<std::vector<double>> mat(rows);
    for (size_t i = 0; i < rows; i++)
    {
        mat[i].resize(cols * 2);
        for (size_t j = 0; j < cols; j++)
        {
            if (j < cols)
            {
                mat[i][j] = static_cast<double>(data[i * cols + j]);
            }
            else
            {
                mat[i][j] = (j - i == rows ? 1.0 : 0.0);
            }
        }
    }

    // Forward elimination: convert left side to row-echelon form
    // using partial pivoting for numerical stability
    for (size_t col = 0, row = 0; col < cols && row < rows; col++)
    {
        // Find the pivot row (first row with non-zero entry in this column)
        size_t pivot = row;
        while (pivot < rows && std::fabs(mat[pivot][col]) < 1e-12)
        {
            pivot++;
        }

        // If entire column is zero below current row, skip this column
        if (pivot == rows)
        {
            continue;
        }

        // Swap pivot row to current position
        if (pivot != row)
        {
            std::swap(mat[row], mat[pivot]);
        }

        // Normalize pivot row so the pivot element becomes 1
        double pivot_val = mat[row][col];
        for (size_t j = col; j < 2 * cols; j++)
        {
            mat[row][j] /= pivot_val;
        }

        // Eliminate this column from all rows below the pivot
        for (size_t i = row + 1; i < rows; i++)
        {
            if (std::fabs(mat[i][col]) >= 1e-12)
            {
                double factor = mat[i][col] / mat[row][col];
                for (size_t j = col; j < 2 * cols; j++)
                {
                    mat[i][j] -= factor * mat[row][j];
                }
            }
        }
    }

    // Extract the right half of the augmented matrix as the result
    MatrixDouble result(rows, cols);
    for (size_t i = 0; i < rows; i++)
    {
        for (size_t j = 0; j < cols; j++)
        {
            result(i, j) = mat[i][cols + j];
        }
    }

    return result;
}
