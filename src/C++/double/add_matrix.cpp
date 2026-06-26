/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:25:31
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:48:02
@FilePath: \asm_matrix_benchmark\src\C++\double\add_matrix.cpp
@Description: add matrix c++ code
*************************************************************/

#include "matrix_double_cpp.h"
#include <stdexcept>

/***********************************************************
@description: add matrix
@return {*}
*************************************************************/
MatrixDouble MatrixDouble::operator+(const MatrixDouble &other) const
{
    if (rows != other.rows || cols != other.cols)
    {
        throw std::invalid_argument("operator+: dimension mismatch");
    }

    // Allocate result matrix and perform element-wise addition
    MatrixDouble res(rows, cols);
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
MatrixDouble &MatrixDouble::operator+=(const MatrixDouble &other)
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
