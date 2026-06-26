/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:42:58
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:07:10
@FilePath: \asm_matrix_benchmark\src\C++\float\scale_matrix.cpp
@Description: scale matrix c++ code
*************************************************************/

#include "matrix_float_cpp.h"

/***********************************************************
@description: mul with const
@return {*}
*************************************************************/
MatrixFloat MatrixFloat::operator*(float scalar) const
{
    // Multiply every element by scalar and return a new matrix
    MatrixFloat res(rows, cols);
    for (size_t i = 0; i < rows * cols; i++)
    {
        res.data[i] = data[i] * scalar;
    }
    return res;
}

/***********************************************************
@description: function above is to fit Matrix * int, this is to fit int * Matrix
@return {*}
*************************************************************/
MatrixFloat operator*(float scalar, const MatrixFloat &m)
{
    return m * scalar;
}
