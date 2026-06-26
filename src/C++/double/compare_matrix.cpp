/************************************************************
@Author: HoodUSSEnterprise
@Date: 2026-06-26 08:44:29
@LastEditors: HoodUSSEnterprise
@LastEditTime: 2026-06-26 08:51:37
@FilePath: \asm_matrix_benchmark\src\C++\double\compare_matrix.cpp
@Description: compare matrix c++ code
*************************************************************/

#include "matrix_double_cpp.h"

/***********************************************************
@description:Equality comparison operator, checks if two matrices have the same dimensions and identical elements
@return {*}
*************************************************************/
bool MatrixDouble::operator==(const MatrixDouble &other) const
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
bool MatrixDouble::operator!=(const MatrixDouble &other) const
{
    return !(*this == other);
}
