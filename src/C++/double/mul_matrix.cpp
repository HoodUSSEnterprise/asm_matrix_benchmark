/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:42:50
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:51:08
@FilePath: \asm_matrix_benchmark\src\C++\double\mul_matrix.cpp
@Description: mul matrix c++ code
*************************************************************/

#include "matrix_double_cpp.h"
#include <stdexcept>

/***********************************************************
@description: mul with new matrix
@return {*}
*************************************************************/
MatrixDouble MatrixDouble::operator*(const MatrixDouble &other) const
{
    if (cols != other.rows)
    {
        throw std::invalid_argument("operator*: inner dimensions must match");
    }

    MatrixDouble res(rows, other.cols);
    // Standard O(n^3) triple-loop matrix multiplication
    for (size_t i = 0; i < rows; i++)
    {
        for (size_t j = 0; j < other.cols; j++)
        {
            double sum = 0;
            for (size_t k = 0; k < cols; k++)
            {
                sum += data[i * cols + k] * other.data[k * other.cols + j];
            }
            res.data[i * res.cols + j] = sum;
        }
    }
    return res;
}

/***********************************************************
@description: *=
@return {*}
*************************************************************/
MatrixDouble &MatrixDouble::operator*=(const MatrixDouble &other)
{
    // Matrix multiplication by self-assignment
    *this = *this * other;
    return *this;
}

/***********************************************************
@description: mul with const number
@return {*}
*************************************************************/
MatrixDouble &MatrixDouble::operator*=(double scalar)
{
    // In-place scalar multiplication
    for (size_t i = 0; i < rows * cols; i++)
    {
        data[i] *= scalar;
    }
    return *this;
}
