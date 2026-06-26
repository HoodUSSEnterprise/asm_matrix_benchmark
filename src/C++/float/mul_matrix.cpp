/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:42:50
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:06:03
@FilePath: \asm_matrix_benchmark\src\C++\float\mul_matrix.cpp
@Description: mul matrix c++ code
*************************************************************/

#include "matrix_float_cpp.h"
#include <stdexcept>

/***********************************************************
@description: mul with new matrix
@return {*}
*************************************************************/
MatrixFloat MatrixFloat::operator*(const MatrixFloat &other) const
{
    if (cols != other.rows)
    {
        throw std::invalid_argument("operator*: inner dimensions must match");
    }

    MatrixFloat res(rows, other.cols);
    // Standard O(n^3) triple-loop matrix multiplication
    for (size_t i = 0; i < rows; i++)
    {
        for (size_t j = 0; j < other.cols; j++)
        {
            long long sum = 0;
            for (size_t k = 0; k < cols; k++)
            {
                // Use long long to avoid integer overflow during accumulation
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
MatrixFloat &MatrixFloat::operator*=(const MatrixFloat &other)
{
    // Matrix multiplication by self-assignment
    *this = *this * other;
    return *this;
}

/***********************************************************
@description: mul with const number
@return {*}
*************************************************************/
MatrixFloat &MatrixFloat::operator*=(float scalar)
{
    // In-place scalar multiplication
    for (size_t i = 0; i < rows * cols; i++)
    {
        data[i] *= scalar;
    }
    return *this;
}
