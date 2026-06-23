/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:37:13
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:20:27
@FilePath: \asm_matrix_benchmark\src\C++\sub_matrix.cpp
@Description: sub matrix c++ code
*************************************************************/
#include "matrix_cpp.h"
#include <stdexcept>

/***********************************************************
@description: sub matrix
@return {*}
*************************************************************/
MatrixInt MatrixInt::operator-(const MatrixInt &other) const
{
    if (rows != other.rows || cols != other.cols)
    {
        throw std::invalid_argument("operator-: dimension mismatch");
    }

    MatrixInt res(rows, cols);
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
MatrixInt &MatrixInt::operator-=(const MatrixInt &other)
{
    if (rows != other.rows || cols != other.cols)
    {
        throw std::invalid_argument("operator-=: dimension mismatch");
    }

    for (size_t i = 0; i < rows * cols; i++)
    {
        data[i] -= other.data[i];
    }
    return *this;
}
