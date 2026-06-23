/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-16 19:42:58
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-23 19:22:39
@FilePath: \asm_matrix_benchmark\src\C++\scale_matrix.cpp
@Description: scale matrix c++ code
*************************************************************/
#include "matrix_cpp.h"

/***********************************************************
@description: mul with const
@return {*}
*************************************************************/
MatrixInt MatrixInt::operator*(int scalar) const
{
    MatrixInt res(rows, cols);
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
MatrixInt operator*(int scalar, const MatrixInt &m)
{
    return m * scalar;
}
