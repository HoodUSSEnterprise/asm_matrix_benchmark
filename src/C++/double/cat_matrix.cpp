/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:00
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:47:01
@FilePath: \asm_matrix_benchmark\src\C++\double\cat_matrix.cpp
@Description: cat matrix c++ code
*************************************************************/

#include "matrix_double_cpp.h"
#include <stdexcept>

/***********************************************************
@description: cat matrix
@param {MatrixDouble} &other
@param {int} axis : 1 means horizon, 0 means vertical
@return {*}
*************************************************************/
MatrixDouble MatrixDouble::cat(const MatrixDouble &other, int axis) const
{
    // Vertical concatenation (stack rows): cols must match
    if (axis == 0)
    {
        if (cols != other.cols)
        {
            throw std::invalid_argument("cat(axis=0): column mismatch");
        }
        MatrixDouble res(rows + other.rows, cols);
        for (size_t i = 0; i < rows + other.rows; i++)
        {
            for (size_t j = 0; j < cols; j++)
            {
                if (i < rows)
                {
                    // Copy from this matrix
                    res.data[i * cols + j] = data[i * cols + j];
                }
                else
                {
                    // Copy from other matrix, offset by this.rows
                    res.data[i * cols + j] = other.data[(i - rows) * cols + j];
                }
            }
        }
        return res;
    }
    // Horizontal concatenation (stack columns): rows must match
    else if (axis == 1)
    {
        if (rows != other.rows)
        {
            throw std::invalid_argument("cat(axis=1): row mismatch");
        }
        size_t res_cols = cols + other.cols;
        MatrixDouble res(rows, res_cols);
        for (size_t i = 0; i < rows; i++)
        {
            // Copy this row from the left matrix
            for (size_t j = 0; j < cols; j++)
            {
                res.data[i * res_cols + j] = data[i * cols + j];
            }
            // Copy this row from the right matrix
            for (size_t j = 0; j < other.cols; j++)
            {
                res.data[i * res_cols + cols + j] = other.data[i * other.cols + j];
            }
        }
        return res;
    }
    else
    {
        throw std::invalid_argument("cat: axis must be 0 or 1");
    }
}
