/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:42:50
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:20:45
@FilePath: \asm_matrix_benchmark\src\C++\mul_matrix.cpp
@Description: mul matrix c++ code
*************************************************************/
#include "matrix_cpp.h"
#include <stdexcept>

/***********************************************************
@description: mul with new matrix
@return {*}
*************************************************************/
MatrixInt MatrixInt::operator*(const MatrixInt &other) const
{
    if (cols != other.rows)
    {
        throw std::invalid_argument("operator*: inner dimensions must match");
    }

    MatrixInt res(rows, other.cols);
    for (size_t i = 0; i < rows; ++i)
    {
        for (size_t j = 0; j < other.cols; ++j)
        {
            long long sum = 0;
            for (size_t k = 0; k < cols; ++k)
            {
                sum += static_cast<long long>(data[i * cols + k]) * other.data[k * other.cols + j];
            }
            res.data[i * res.cols + j] = static_cast<int>(sum);
        }
    }
    return res;
}

/***********************************************************
@description: *=
@return {*}
*************************************************************/
MatrixInt &MatrixInt::operator*=(const MatrixInt &other)
{
    *this = *this * other;
    return *this;
}

/***********************************************************
@description: mul with const number
@return {*}
*************************************************************/
MatrixInt &MatrixInt::operator*=(int scalar)
{
    for (size_t i = 0; i < rows * cols; ++i)
    {
        data[i] *= scalar;
    }
    return *this;
}
