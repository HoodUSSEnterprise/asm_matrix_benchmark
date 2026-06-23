/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:39:00
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:24:54
@FilePath: \asm_matrix_benchmark\src\C++\cat_matrix.cpp
@Description: cat matrix c++ code
*************************************************************/
#include "matrix_cpp.h"
#include <stdexcept>

/***********************************************************
@description: cat matrix
@param {MatrixInt} &other
@param {int} axis : 1 means horizon, 0 means vertical
@return {*}
*************************************************************/
MatrixInt MatrixInt::cat(const MatrixInt &other, int axis) const
{
    if (axis == 0)
    {
        if (cols != other.cols)
        {
            throw std::invalid_argument("cat(axis=0): column mismatch");
        }
        MatrixInt res(rows + other.rows, cols);
        for (size_t i = 0; i < rows + other.rows; i++)
        {
            for (size_t j = 0; j < cols; j++)
            {
                if (i < rows)
                {
                    res.data[i * cols + j] = data[i * cols + j];
                }
                else
                {
                    res.data[i * cols + j] = other.data[(i - rows) * cols + j];
                }
            }
        }
        return res;
    }
    else if (axis == 1)
    {
        if (rows != other.rows)
        {
            throw std::invalid_argument("cat(axis=1): row mismatch");
        }
        size_t res_cols = cols + other.cols;
        MatrixInt res(rows, res_cols);
        for (size_t i = 0; i < rows; i++)
        {
            for (size_t j = 0; j < cols; j++)
            {
                res.data[i * res_cols + j] = data[i * cols + j];
            }
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
