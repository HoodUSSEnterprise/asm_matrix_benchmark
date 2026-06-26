/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:37:13
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:07:39
@FilePath: \asm_matrix_benchmark\src\C++\float\sub_matrix.cpp
@Description: sub matrix c++ code
*************************************************************/

#include "matrix_float_cpp.h"
#include <stdexcept>

/***********************************************************
@description: sub matrix
@return {*}
*************************************************************/
MatrixFloat MatrixFloat::operator-(const MatrixFloat &other) const
{
    if (rows != other.rows || cols != other.cols)
    {
        throw std::invalid_argument("operator-: dimension mismatch");
    }

    // Allocate result matrix and perform element-wise subtraction
    MatrixFloat res(rows, cols);
    for (size_t i = 0; i < rows * cols; i++)
    {
        res.data[i] = data[i] - other.data[i];
    }
    return res;
}

/***********************************************************
@description: -=
@return {*}
*************************************************************/
MatrixFloat &MatrixFloat::operator-=(const MatrixFloat &other)
{
    if (rows != other.rows || cols != other.cols)
    {
        throw std::invalid_argument("operator-=: dimension mismatch");
    }

    // In-place element-wise subtraction
    for (size_t i = 0; i < rows * cols; i++)
    {
        data[i] -= other.data[i];
    }
    return *this;
}
