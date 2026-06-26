/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-23 17:36:45
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 09:03:31
@FilePath: \asm_matrix_benchmark\src\C++\float\compare_matrix.cpp
@Description: compare matrix c++ code
*************************************************************/

#include "matrix_float_cpp.h"

/***********************************************************
@description:Equality comparison operator, checks if two matrices have the same dimensions and identical elements
@return {*}
*************************************************************/
bool MatrixFloat::operator==(const MatrixFloat &other) const
{
    // Dimensions must match first
    if (rows != other.rows || cols != other.cols)
    {
        return false;
    }
    // Compare every element in row-major order
    for (size_t i = 0; i < rows * cols; i++)
    {
        if (data[i] != other.data[i])
        {
            return false;
        }
    }
    return true;
}

/***********************************************************
@description:Inequality comparison operator, checks if two matrices are different
@return {*}
*************************************************************/
bool MatrixFloat::operator!=(const MatrixFloat &other) const
{
    return !(*this == other);
}
