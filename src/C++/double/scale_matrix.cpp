/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:42:58
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:55:14
@FilePath: \asm_matrix_benchmark\src\C++\double\scale_matrix.cpp
@Description: scale matrix c++ code
*************************************************************/

#include "matrix_double_cpp.h"

/***********************************************************
@description: mul with const
@return {*}
*************************************************************/
MatrixDouble MatrixDouble::operator*(double scalar) const
{
    // Multiply every element by scalar and return a new matrix
    MatrixDouble res(rows, cols);
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
MatrixDouble operator*(double scalar, const MatrixDouble &m)
{
    return m * scalar;
}
