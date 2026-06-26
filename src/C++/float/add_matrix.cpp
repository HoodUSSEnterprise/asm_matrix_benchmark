/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:25:31
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:03:12
@FilePath: \asm_matrix_benchmark\src\C++\float\add_matrix.cpp
@Description: add matrix c++ code
*************************************************************/

#include "matrix_float_cpp.h"
#include <stdexcept>

/***********************************************************
@description: add matrix
@return {*}
*************************************************************/
MatrixFloat MatrixFloat::operator+(const MatrixFloat &other) const
{
    if (rows != other.rows || cols != other.cols)
    {
        throw std::invalid_argument("operator+: dimension mismatch");
    }

    // Allocate result matrix and perform element-wise addition
    MatrixFloat res(rows, cols);
    for (size_t i = 0; i < rows * cols; i++)
    {
        res.data[i] = data[i] + other.data[i];
    }
    return res;
}

/***********************************************************
@description: +=
@return {*}
*************************************************************/
MatrixFloat &MatrixFloat::operator+=(const MatrixFloat &other)
{
    if (rows != other.rows || cols != other.cols)
    {
        throw std::invalid_argument("operator+=: dimension mismatch");
    }

    // In-place element-wise addition
    for (size_t i = 0; i < rows * cols; i++)
    {
        data[i] += other.data[i];
    }
    return *this;
}
